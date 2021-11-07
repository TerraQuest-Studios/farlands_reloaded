minetest.register_node('fl_light_sources:torch', {
	description = 'Torch',
	drawtype = 'nodebox',
	tiles = {
		{name = 'more_fire_torch_top.png'},
		{name = 'more_fire_torch_bottom.png'},
		{name = 'more_fire_torch_side.png'},
	},
	inventory_image = 'more_fire_torch_inv.png',
	wield_image = 'more_fire_torch_inv.png',
	paramtype = 'light',
	paramtype2 = 'wallmounted',
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	light_source = 14,
	node_box = {
		type = 'wallmounted',
		wall_top    = {-0.0625, -0.0625, -0.0625, 0.0625, 0.5   , 0.0625},
		wall_bottom = {-0.0625, -0.5   , -0.0625, 0.0625, 0.0625, 0.0625},
		wall_side   = {-0.5   , -0.5   , -0.0625, -0.375, 0.0625, 0.0625},
	},
	selection_box = {
		type = 'wallmounted',
		wall_top    = {-0.1, -0.05, -0.1, 0.1, 0.5   , 0.1},
		wall_bottom = {-0.1, -0.5   , -0.1, 0.1, 0.0625, 0.1},
		wall_side   = {-0.35, -0.5  , -0.1, -0.5, 0.0625, 0.1},
	},
	groups = {dig_generic = 4, flammable = 1, attached_node = 1},
})

minetest.register_craft({
    output = "fl_light_sources:torch",
    type = "shapeless",
    recipe = {"fl_trees:stick", "fl_ores:coal_ore"}
})

minetest.register_node("fl_light_sources:lantern_c", {
    description = "lantern",
    drawtype = "mesh",
    mesh = "farlands_lantern_c.obj",
    tiles = {"farlands_lantern.png", "farlands_lantern_metal.png"},
    paramtype = 'light',
    selection_box = {
        type = "fixed",
        fixed = {
            {-3/16, 0, -3/16, 3/16, 0.5, 3/16},
        },
    },
    collision_box = {
        type = "fixed",
        fixed = {
            {-3/16, 0, -3/16, 3/16, 0.5, 3/16},
        },
    },
    drop = "fl_light_sources:lantern",
    light_source = 14,
    groups = {dig_stone = 2, lantern = 1, not_in_creative_inventory = 1}
})

minetest.register_node("fl_light_sources:lantern", {
    description = "lantern",
    drawtype = "mesh",
    mesh = "farlands_lantern_f.obj",
    tiles = {"farlands_lantern.png", "farlands_lantern_metal.png"},
    paramtype = 'light',
    light_source = 14,
    selection_box = {
        type = "fixed",
        fixed = {
            {-3/16, -0.5, -3/16, 3/16, 0, 3/16},
        },
    },
    collision_box = {
        type = "fixed",
        fixed = {
            {-3/16, -0.5, -3/16, 3/16, 0, 3/16},
        },
    },
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then return end
        if pointed_thing.under.y-pointed_thing.above.y == 1 then
            local stack = ItemStack(itemstack)
            stack:set_name("fl_light_sources:lantern_c")
            minetest.item_place(stack, placer, pointed_thing)
            itemstack:take_item()
            return itemstack
        end
        minetest.item_place(itemstack, placer, pointed_thing)
        itemstack:take_item()
        return itemstack
    end,
    groups = {dig_stone = 2, lantern = 1}
})

minetest.register_craft({
    output = "fl_light_sources:lantern",
    recipe = {
        {"fl_ores:iron_ingot", "fl_ores:iron_ingot", "fl_ores:iron_ingot"},
        {"fl_ores:iron_ingot", "fl_light_sources:torch", "fl_ores:iron_ingot"},
        {"fl_ores:iron_ingot", "fl_ores:iron_ingot", "fl_ores:iron_ingot"},
    }
})

minetest.register_node("fl_light_sources:chain", {
    description = "chain",
    drawtype = "mesh",
    mesh = "farlands_chain.obj",
    paramtype = "light",
    paramtype2 = "facedir",
    place_param2 = 0,
    tiles = {"farlands_chain_1.png", "farlands_chain_2.png"},
    selection_box = {
        type = "fixed",
        fixed = {
            {-1/16, -0.5, -1/16, 1/16, 0.5, 1/16},
        },
    },
    collision_box = {
        type = "fixed",
        fixed = {
            {-1/16, -0.5, -1/16, 1/16, 0.5, 1/16},
        },
    },
    _dungeon_loot = {chance = 0.4, count = {4, 22}},
    groups = {dig_stone = 1}
})

minetest.register_craft({
    output = "fl_light_sources:chain",
    recipe = {
        {"", "fl_ores:iron_ingot", ""},
        {"", "fl_ores:iron_ingot", ""},
        {"", "fl_ores:iron_ingot", ""},
    }
})