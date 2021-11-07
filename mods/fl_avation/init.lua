--localize stuff
local abs = math.abs
local min = math.min
--vars
local speed_limit = 10

minetest.register_entity("fl_avation:airballoon", {
    initial_properties = {
        visual = "mesh",
        mesh = "farlands_airballoon.b3d",
        textures = {"farlands_airballoon.png"},
        physical = true,
        collide_with_objects = true,
        collisionbox = {-0.8, -0.2, -0.8, 0.8, 1.8, 0.8},
    },

    on_step = function(self, dtime, moveresult)
        --mobkit.stepfunc(self, dtime, moveresult)
        --start mobkit faking
        self.dtime = min(dtime,0.2)
        self.colinfo = moveresult
        self.height = mobkit.get_box_height(self)
        --end mobkit faking

        local driver
        local controls
        if mobkit.recall(self, "driver") and minetest.get_player_by_name(mobkit.recall(self, "driver")) then
            driver = minetest.get_player_by_name(mobkit.recall(self, "driver"))
            controls = driver:get_player_control()
        else
            mobkit.forget(self, "driver")
            controls = {}
        end
        local old_vel = self.object:get_velocity()
        local vel = self.object:get_velocity()

        --up
        if controls.jump and abs(vel.y) < speed_limit then
            vel.y = vel.y + .5
        elseif abs(vel.y) ~= 0 and abs(vel.y) == vel.y then
            vel.y = vel.y - .1
        end
        --down
        if controls.sneak and abs(vel.y) < speed_limit then
            vel.y = vel.y - .5
        elseif abs(vel.y) ~= 0 and abs(vel.y) ~= vel.y then
            vel.y = vel.y + .1
        end
        --[[
        --left
        if controls.left then
            local val = vector.divide(vector.new(vel.x,0,vel.z), minetest.yaw_to_dir(self.object:get_yaw()))
            local nyaw = self.object:get_yaw()+0.19
            self.object:set_yaw(nyaw)
            val = vector.multiply(minetest.yaw_to_dir(nyaw), val)
            vel = vector.new(val.x, vel.y, val.z)
        end
        --right
        if controls.right then self.object:set_yaw(self.object:get_yaw()-0.19) end
        --up
        if controls.up and abs(vel.z) < speed_limit and abs(vel.x) < speed_limit then
            local vyaw = minetest.yaw_to_dir(self.object:get_yaw())
            vel = vector.add(vector.add(vyaw, vector.new(0.5,0,0.5)), vel)
        elseif abs(vel.x) ~= 0 and abs(vel.x) ~= vel.x and abs(vel.z) ~= 0 and abs(vel.z) ~= vel.z then
            local vyaw = minetest.yaw_to_dir(self.object:get_yaw())
            vel = vector.add(vector.subtract(vyaw, vector.new(0.5,0,0.5)), vel)
        end
        --]]

        --minetest.chat_send_all(dump(self.object:get_velocity()))

        --setting end resulting vel if changed
        if not vector.equals(vel, old_vel) then
            self.object:add_velocity(vector.subtract(vel, old_vel))
        end

        --more mobkit faking
        self.lastvelocity = self.object:get_velocity()
        self.time_total=self.time_total+self.dtime
        --end more mobkit faking
    end,
    on_activate = mobkit.actfunc,
    get_staticdata = mobkit.statfunc,

    on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
        --self.object:set_rotation({x=5,y=0,z=0})
        --self.object:set_velocity(vector.new(0,-1,0))
        self.object:set_animation({x=2,y=20})
    end,
    on_rightclick = function(self, clicker)
        if mobkit.recall(self, "driver") and mobkit.recall(self, "driver") == clicker:get_player_name() then
            mobkit.forget(self, "driver")
            clicker:set_detach()
            fl_player.ignore[clicker:get_player_name()] = nil
        elseif not mobkit.recall(self, "driver") then
            mobkit.remember(self, "driver", clicker:get_player_name())
            clicker:set_attach(self.object)
            fl_player.ignore[clicker:get_player_name()] = true
        end
    end
})