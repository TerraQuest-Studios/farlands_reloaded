minetest.register_node("fl_topsoil:dirt", {
    description = "dirt",
    tiles = {"farlands_dirt.png"},
    _dungeon_loot = {name = "fl_topsoil:dirt", chance = 0.6, count = {2, 16}, y = {-64, 32768}},
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_node("fl_topsoil:dirt_with_grass", {
    description = "grass",
    tiles = {
        "farlands_grass.png",
        "farlands_dirt.png",
        "farlands_dirt.png^farlands_grass_side.png",
    },
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_node("fl_topsoil:savannah_dirt", {
    description = "savannah dirt",
    tiles = {"farlands_savannah_dirt.png"},
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_node("fl_topsoil:savannah_dirt_with_grass", {
    description = "savannah grass",
    tiles = {
        "farlands_savannah_grass.png",
        "farlands_savannah_dirt.png",
        "farlands_savannah_dirt.png^farlands_savannah_grass_side.png",
    },
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_node("fl_topsoil:dirt_with_snow", {
    description = "dirt wth snow",
    tiles = {
        "farlands_snow_block.png",
        "farlands_dirt.png",
        "farlands_dirt.png^farlands_snow_block_side.png",
    },
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_node("fl_topsoil:ice", {
    description = "ice",
    tiles = {"farlands_ice.png"},
    groups = {oddly_breakable_by_hand = 3, melts = 1},
})

minetest.register_node("fl_topsoil:condensed_ice", {
    description = "condensed ice",
    tiles = {"farlands_condensed_ice.png"},
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_node("fl_topsoil:snow_block", {
    description = "snow block",
    tiles = {"farlands_snow_block.png"},
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_node("fl_topsoil:snow", {
    description = "snow",
    tiles = {"farlands_snow_block.png"},
    groups = {oddly_breakable_by_hand = 3, falling_node=1, float=1},
    inventory_image = "farlands_snow.png",
    wield_image = "farlands_snow.png",
    paramtype = "light",
    paramtype2 = "leveled",
    leveled = 8,
    sunlight_propagates = true,
    drawtype = "nodebox",
    node_placement_prediction = "",
    node_box = {
        type = "leveled",
        fixed = {-0.5, -0.5, -0.5, 0.5, -0.5, 0.5},
    },
    collision_box = {
        type = "leveled",
        fixed = {-0.5, -0.5, -0.5, 0.5, -0.5, 0.5},
    },
    selection_box = {
        type = "leveled",
        fixed = {-0.5, -0.5, -0.5, 0.5, -0.5, 0.5},
    },
    on_dig = function(pos, node, digger)
        local level = minetest.get_node_level(pos)
        minetest.node_dig(pos, node, digger)
        local inv = digger:get_inventory()
        if not inv then return end
        local inv_add = inv:add_item("main", "fl_topsoil:snow "..tostring(level/8-1))
        if not inv_add:is_empty() then
            minetest.add_item(pos, inv_add)
        end
    end,
    on_place = function(itemstack, player, pointed_thing)
        local under_node = minetest.get_node_or_nil(pointed_thing.under)
        if not under_node then return itemstack, false end

        if under_node.name == "fl_topsoil:snow" then
            local level = minetest.get_node_level(pointed_thing.under)
            if level >= 56 then
                minetest.swap_node(pointed_thing.under, {name = "fl_topsoil:snow_block"})
                itemstack:take_item()
                return itemstack, true
            else
                level = level + 8
                minetest.set_node_level(pointed_thing.under, level)
                itemstack:take_item()
                return itemstack, true
            end
        else
            return minetest.item_place_node(itemstack, player, pointed_thing)
        end
    end,
})

minetest.register_alias("fl_terrain:dirt", "fl_topsoil:dirt")
minetest.register_alias("fl_terrain:dirt_with_grass", "fl_topsoil:dirt_with_grass")
minetest.register_alias("fl_terrain:sand", "fl_topsoil:sand")
minetest.register_alias("fl_terrain:ice", "fl_topsoil:ice")
minetest.register_alias("fl_terrain:condensed_ice", "fl_topsoil:condensed_ice")
minetest.register_alias("fl_terrain:snow_block", "fl_topsoil:snow_block")
minetest.register_alias("fl_terrain:snow", "fl_topsoil:snow")