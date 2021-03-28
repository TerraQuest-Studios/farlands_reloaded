minetest.register_node("fl_terrain:dirt", {
    description = "dirt",
    tiles = {"farlands_dirt.png"},
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_node("fl_terrain:dirt_with_grass", {
    description = "grass",
    tiles = {
        "farlands_grass.png",
        "farlands_dirt.png",
        "farlands_dirt.png^farlands_grass_side.png",
    },
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_node("fl_terrain:ice", {
    description = "ice",
    tiles = {"farlands_ice.png"},
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_node("fl_terrain:condensed_ice", {
    description = "condensed ice",
    tiles = {"farlands_condensed_ice.png"},
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_node("fl_terrain:snow_block", {
    description = "snow block",
    tiles = {"farlands_snow_block.png"},
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_node("fl_terrain:snow", {
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
        local inv_add = inv:add_item("main", "fl_terrain:snow "..tostring(level/8-1))
        if not inv_add:is_empty() then
            minetest.add_item(pos, inv_add)
        end
    end,
    on_place = function(itemstack, player, pointed_thing)
        local under_node = minetest.get_node_or_nil(pointed_thing.under)
        if not under_node then return itemstack, false end

        if under_node.name == "fl_terrain:snow" then
            local level = minetest.get_node_level(pointed_thing.under)
            if level >= 56 then
                minetest.swap_node(pointed_thing.under, {name = "fl_terrain:snow_block"})
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