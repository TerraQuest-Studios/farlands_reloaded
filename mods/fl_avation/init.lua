--localize stuff
local min, max, abs = math.min, math.max, math.abs
local sin, cos = math.sin, math.cos

--vars
local max_speed = 8         -- forward, nodes per second
local max_reverse = 3
local climb_speed = 4
local sink_speed = 1        -- unpiloted balloons slowly drift down
local turn_speed = 1.5      -- radians per second
local accel = 1.5           -- how fast velocity eases toward the target, per second
local turn_accel = 4

-- the propellers make one full turn over frames 0-20
local spin_frames = {x = 0, y = 20}
local spin_idle = 10
local spin_full = 60

-- attach offsets are in model units (a tenth of a node) since visual_size is 1
local seat_pos = vector.new(0, 1, 0)
local eye_offset = vector.new(0, -4, 0)

local function approach(cur, target, rate)
    return cur + (target - cur) * min(1, rate)
end

local function seat(self, player)
    local name = player:get_player_name()
    self.driver = name
    fl_player.ignore[name] = true
    player:set_attach(self.object, "", seat_pos, vector.new(0, 0, 0))
    player:set_eye_offset(eye_offset, eye_offset)
    player:set_animation(fl_player.animations["sit"], 15)
end

local function unseat(self)
    local name = self.driver
    if not name then return end
    self.driver = nil
    fl_player.ignore[name] = nil
    local player = core.get_player_by_name(name)
    if not player then return end
    player:set_detach()
    player:set_eye_offset(vector.new(0, 0, 0), vector.new(0, 0, 0))

    -- step out beside the basket rather than into the balloon's collisionbox
    local pos = self.object:get_pos()
    if pos then
        local yaw = self.object:get_yaw() + math.pi / 2
        local side = vector.new(-sin(yaw), 0, cos(yaw))
        core.after(0.1, function()
            local p = core.get_player_by_name(name)
            if p and not p:get_attach() then
                p:set_pos(vector.offset(vector.add(pos, vector.multiply(side, 1.8)), 0, 0.5, 0))
            end
        end)
    end
end

core.register_entity("fl_avation:airballoon", {
    initial_properties = {
        visual = "mesh",
        mesh = "farlands_airballoon.glb",
        textures = {"farlands_airballoon.png"},
        physical = true,
        collide_with_objects = true,
        -- covers the balloon too so it can't be flown into ceilings
        collisionbox = {-1.1, -0.18, -1.1, 1.1, 3.7, 1.1},
        -- just the basket, so the rider can still point at it to get out
        selectionbox = {-1.1, -0.18, -1.1, 1.1, 0.65, 1.1},
        static_save = true,
    },

    on_activate = function(self, staticdata)
        self.object:set_armor_groups({immortal = 1})
        self.object:set_acceleration(vector.new(0, 0, 0))
        self.object:set_animation(spin_frames, 0, 0, true)
        self.turn = 0
        self.spin = 0
    end,

    on_deactivate = function(self)
        unseat(self)
    end,

    on_step = function(self, dtime)
        if self.driver and not core.get_player_by_name(self.driver) then
            self.driver = nil
        end
        local driver = self.driver and core.get_player_by_name(self.driver)
        local controls = driver and driver:get_player_control() or {}

        local yaw = self.object:get_yaw()
        local vel = self.object:get_velocity()
        local dir = vector.new(-sin(yaw), 0, cos(yaw))

        --turning
        local target_turn = 0
        if controls.left then target_turn = target_turn + turn_speed end
        if controls.right then target_turn = target_turn - turn_speed end
        self.turn = approach(self.turn, target_turn, turn_accel * dtime)
        if self.turn ~= 0 then
            yaw = yaw + self.turn * dtime
            self.object:set_yaw(yaw)
            dir = vector.new(-sin(yaw), 0, cos(yaw))
        end

        --thrust, only along the heading so the balloon doesn't drift sideways forever
        local forward = vel.x * dir.x + vel.z * dir.z
        local target_forward = 0
        if controls.up then
            target_forward = max_speed
        elseif controls.down then
            target_forward = -max_reverse
        end
        forward = approach(forward, target_forward, accel * dtime)
        local side = vector.subtract(vector.new(vel.x, 0, vel.z), vector.multiply(dir, vel.x * dir.x + vel.z * dir.z))
        side = vector.multiply(side, max(0, 1 - 3 * dtime))

        --lift
        local target_y = driver and 0 or -sink_speed
        if controls.jump then
            target_y = climb_speed
        elseif controls.sneak then
            target_y = -climb_speed
        end
        local y = approach(vel.y, target_y, accel * dtime)

        self.object:set_velocity(vector.new(
            dir.x * forward + side.x,
            y,
            dir.z * forward + side.z
        ))

        --propellers spin with the throttle
        local spin = 0
        if driver then
            spin = spin_idle + (spin_full - spin_idle) * min(1, abs(forward) / max_speed)
        end
        spin = math.floor(spin / 5 + 0.5) * 5
        if spin ~= self.spin then
            self.spin = spin
            self.object:set_animation_frame_speed(spin)
        end
    end,

    on_punch = function(self, puncher)
        if self.driver or not (puncher and puncher:is_player()) then return true end

        local inv = puncher:get_inventory()
        if not (core.is_creative_enabled(puncher:get_player_name())
            and inv:contains_item("main", "fl_avation:airballoon"))
        then
            local leftover = inv:add_item("main", "fl_avation:airballoon")
            if not leftover:is_empty() then
                core.add_item(self.object:get_pos(), leftover)
            end
        end
        self.object:remove()
        return true
    end,

    on_rightclick = function(self, clicker)
        if not (clicker and clicker:is_player()) then return end
        if self.driver == clicker:get_player_name() then
            unseat(self)
        elseif not self.driver and not clicker:get_attach() then
            seat(self, clicker)
        end
    end,
})

core.register_craftitem("fl_avation:airballoon", {
    description = "Hot Air Balloon",
    inventory_image = "farlands_airballoon_inv.png",
    wield_image = "farlands_airballoon_inv.png",
    stack_max = 1,
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then return itemstack end

        local node = core.get_node(pointed_thing.under)
        local def = core.registered_nodes[node.name]
        if def and def.on_rightclick and placer and not placer:get_player_control().sneak then
            return def.on_rightclick(pointed_thing.under, node, placer, itemstack, pointed_thing)
        end

        local pos = pointed_thing.above
        if core.is_protected(pos, placer and placer:get_player_name() or "") then
            return itemstack
        end
        local obj = core.add_entity(vector.offset(pos, 0, -0.3, 0), "fl_avation:airballoon")
        if obj and placer then
            obj:set_yaw(placer:get_look_horizontal())
        end

        if not (placer and core.is_creative_enabled(placer:get_player_name())) then
            itemstack:take_item()
        end
        return itemstack
    end,
})

-- don't leave players stuck in the seat state when they leave or die
local function drop_rider(player)
    local parent = player:get_attach()
    local ent = parent and parent:get_luaentity()
    if ent and ent.name == "fl_avation:airballoon" and ent.driver == player:get_player_name() then
        unseat(ent)
    end
end

core.register_on_leaveplayer(drop_rider)
core.register_on_dieplayer(drop_rider)
