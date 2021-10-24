minetest.register_entity("fl_avation:airballoon", {
    initial_properties = {
        visual = "mesh",
        mesh = "farlands_airballoon.b3d",
        textures = {"farlands_airballoon.png"},
        physical = true,
        collide_with_objects = true,
        collisionbox = {-0.8, -0.2, -0.8, 0.8, 1.8, 0.8},
    },
    on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
        --self.object:set_rotation({x=5,y=0,z=0})
        self.object:set_velocity(vector.new(0,-1,0))
    end,
})