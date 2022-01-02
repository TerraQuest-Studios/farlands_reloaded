local function speed_check(vec, limit)
    local v = vector.apply(vec, math.abs)
    local l = limit
    if v.x >= l then return false
    elseif v.y >= l then return false
    elseif v.z >= l then return false end
    return true
end

minetest.register_entity("fl_trains:train_engine", {
    --mte object properties
    initial_properties = {
        physical = true,
        --stepheight = 0.4,
        collide_with_objects = true,
        collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        visual = "mesh",
        mesh = "farlands_train_engine.obj",
        textures = {
            "farlands_train_engine.png",
        },
        backface_culling = false,
        visual_size = {x=10, y=10, z=10},
        static_save = true,
        damage_texture_modifier = "^[colorize:#FF000040"
    },

    --on_step = mobkit.stepfunc, --this is required
    on_activate = function(self, staticdata, dtime_s)
        --load memory
        local sdata = minetest.deserialize(staticdata)
        if sdata then
            for k,v in pairs(sdata) do
                self[k] = v
            end
        end
        if not self.memory then self.memory = {} end
        --other stuff
    end,
    get_staticdata = function(self)
        local tmp = {memory = self.memory}
        return minetest.serialize(tmp)
    end,
    on_step = function(self, dtime, moveresult)
        local yaw = tonumber(string.format("%.2f", self.object:get_yaw()))
        local dir = vector.round(minetest.yaw_to_dir(yaw))
        local pos = self.object:get_pos()
        local ndir = dir

        local vel = self.object:get_velocity()
        local player
        if self.memory.driver then player = minetest.get_player_by_name(self.memory.driver) end
        if not player then return end
        if player:get_player_control().up and speed_check(vel, 5) then
            self.object:add_velocity(vector.multiply(dir, 0.2))
        elseif player:get_player_control().down and speed_check(vel, 5) then
            self.object:add_velocity(vector.multiply(dir, -0.2))
            ndir = vector.multiply(ndir, -1)
        end

        local node = minetest.get_node_or_nil(vector.add(ndir, pos))
        if not node then self.object:set_velocity(vector.new(0,0,0)) return end
        if node.name ~= "fl_trains:straight_track" then
            self.object:set_velocity(vector.new(0,0,0))
            return
        end
    end,

    on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
        self.object:remove()
    end,

    on_rightclick=function(self, clicker)
        if #self.object:get_children() > 0 then
            for _, obj in pairs(self.object:get_children()) do
                if obj:is_player() and obj:get_player_name() == self.memory.driver then
                    obj:set_detach()
                    obj:set_properties({visual_size = vector.new(1,1,1)})
                    fl_player.ignore[obj:get_player_name()] = nil
                    obj:set_eye_offset(vector.new(0,0,0), vector.new(0,0,0))
                    self.memory.driver = nil
                end
            end
        else
            clicker:set_attach(self.object, "", vector.new(0,-0.49,0.45), vector.new(0,0,0), true)
            clicker:set_properties({visual_size = vector.new(.075,.075,.075)})
            fl_player.ignore[clicker:get_player_name()] = true
            clicker:set_animation(fl_player.animations["sit"], 15)
            clicker:set_eye_offset(vector.new(0,-13,5.5), vector.new(0,-13,5.5))
            self.memory.driver = clicker:get_player_name()
        end
    end,
})

minetest.register_craftitem("fl_trains:train_engine", {
    description = "train_engine",
    inventory_image = "farlands_cart_item.png",
    wield_image = "farlands_cart_item.png",
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then return end
        local node = minetest.get_node_or_nil(pointed_thing.under)
        if string.find(node.name, "fl_trains") then
            local ent = minetest.add_entity(pointed_thing.under, "fl_trains:train_engine")
            if node.name == "fl_trains:straight_track" and node.param2%2 ~= 0 then
                ent:set_rotation(vector.new(0,90*(math.pi/180),0))
                --minetest.chat_send_all(ent:get_yaw())
            end
        end
    end,
    groups = {not_in_creative_inventory = 1}
})