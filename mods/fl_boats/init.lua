minetest.register_entity("fl_boats:boat", {
    initial_properties = {
        visual = "mesh",
        mesh = "farlands_boat.obj",
        textures = {"farlands_apple_planks.png"},
        physical = true,
        collide_with_objects = true,
        collisionbox = {-0.5, -0.1, -0.5, 0.5, 0.5, 0.5},
    },
    on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
        --self.object:set_rotation({x=5,y=0,z=0})
        self.object:set_velocity(vector.new(0,-1,0))
    end,
})