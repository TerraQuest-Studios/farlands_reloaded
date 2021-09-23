minetest.register_entity("fl_trains:cart", {
    --mte object properties
    initial_properties = {
        physical = true,
        --stepheight = 0.4,
        collide_with_objects = true,
        collisionbox = {-0.5, 0.0, -0.5, 0.5, 0, 0.5},
        visual = "mesh",
        mesh = "farlands_cart_demo.obj",
        textures = {
            "farlands_cart.png",
        },
        backface_culling = false,
        visual_size = {x=10, y=10, z=10},
        static_save = true,
        damage_texture_modifier = "^[colorize:#FF000040"
    },

    --on_step = mobkit.stepfunc, --this is required
    --on_activate = fl_wildlife.actfunc, --this is required as well(useing custom that calls mobkits and adds nametags)
    --get_staticdata = mobkit.statfunc, --who knows, no documentation (probably save entity data)

    --more mte properties
    on_punch=function(self, puncher, time_from_last_punch, tool_capabilities, dir)
        minetest.chat_send_all("punched")
    end,
})

minetest.register_craftitem("fl_trains:cart", {
    description = "cart",
    inventory_image = "farlands_cart_item.png",
    wield_image = "farlands_cart_item.png",
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then return end
        local node = minetest.get_node_or_nil(pointed_thing.under)
        if string.find(node.name, "fl_trains") then
            minetest.add_entity(pointed_thing.under, "fl_trains:cart")
        end
    end,
    groups = {not_in_creative_inventory = 1}
})