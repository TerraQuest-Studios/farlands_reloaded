minetest.register_node("fl_topsoil:coarse_dirt", {
    description = "coarse dirt",
    tiles = {"farlands_coarse_dirt.png"},
    sounds = fl_topsoil.sounds.grass(),
    groups = {dig_dirt = 3, farm_convert = 1},
})

minetest.register_node("fl_topsoil:dirt", {
    description = "dirt",
    tiles = {"farlands_dirt.png"},
    _dungeon_loot = {chance = 0.6, count = {2, 16}, y = {-64, 32768}},
    sounds = fl_topsoil.sounds.grass(),
    groups = {dig_dirt = 3, farm_convert = 1},
})

minetest.register_node("fl_topsoil:dry_farmland", {
    description = "dirt",
    tiles = {
        "farlands_dirt.png^farlands_farmland_dry.png",
        "farlands_dirt.png",
        "farlands_dirt.png",
    },
    drop = "fl_topsoil:dirt",
    sounds = fl_topsoil.sounds.grass(),
    groups = {dig_dirt = 2, not_in_creative_inventory = 1, farmland = 1},
})

minetest.register_node("fl_topsoil:wet_farmland", {
    description = "dirt",
    tiles = {
        "farlands_dirt.png^farlands_farmland_wet.png",
        "farlands_dirt.png",
        "farlands_dirt.png^farlands_farmland_wet_side.png",
    },
    drop = "fl_topsoil:dirt",
    sounds = fl_topsoil.sounds.grass(),
    groups = {dig_dirt = 2, not_in_creative_inventory = 1, farmland = 1, plantable = 1},
})

minetest.register_node("fl_topsoil:dirt_with_grass", {
    description = "grass",
    tiles = {
        "farlands_grass.png",
        "farlands_dirt.png",
        "farlands_dirt.png^farlands_grass_side.png",
    },
    sounds = fl_topsoil.sounds.grass(),
    groups = {dig_dirt = 1, farm_convert = 1},
})

minetest.register_node("fl_topsoil:savannah_dirt", {
    description = "savannah dirt",
    tiles = {"farlands_savannah_dirt.png"},
    sounds = fl_topsoil.sounds.grass(),
    groups = {dig_dirt = 3},
})

minetest.register_node("fl_topsoil:savannah_dirt_with_grass", {
    description = "savannah grass",
    tiles = {
        "farlands_savannah_grass.png",
        "farlands_savannah_dirt.png",
        "farlands_savannah_dirt.png^farlands_savannah_grass_side.png",
    },
    sounds = fl_topsoil.sounds.grass(),
    groups = {dig_dirt = 1},
})

minetest.register_node("fl_topsoil:dirt_with_snow", {
    description = "dirt wth snow",
    tiles = {
        "farlands_snow_block.png",
        "farlands_dirt.png",
        "farlands_dirt.png^farlands_snow_block_side.png",
    },
    sounds = fl_topsoil.sounds.snow(),
    groups = {dig_dirt = 1, farm_convert = 1},
})

minetest.register_node("fl_topsoil:ice", {
    description = "ice",
    tiles = {"farlands_ice.png"},
    sounds = fl_topsoil.sounds.snow(),
    _dungeon_loot = {chance = 0.7, count = {4, 32}, types = {"tundra", "icy", "snowygrassland"}},
    groups = {dig_snow = 2, melts = 1, spawn_blacklist = 1},
})

minetest.register_node("fl_topsoil:condensed_ice", {
    description = "condensed ice",
    tiles = {"farlands_condensed_ice.png"},
    sounds = fl_topsoil.sounds.snow(),
    groups = {dig_snow = 1, stairable = 1},
})

minetest.register_node("fl_topsoil:snow_block", {
    description = "snow block",
    tiles = {"farlands_snow_block.png"},
    sounds = fl_topsoil.sounds.snow(),
    groups = {dig_snow = 3},
})

minetest.register_node("fl_topsoil:snow", {
    description = "snow",
    tiles = {"farlands_snow_block.png"},
    sounds = fl_topsoil.sounds.snow(),
    groups = {dig_snow = 4, falling_node=1, float=1},
    inventory_image = "farlands_snow.png",
    wield_image = "farlands_snow.png",
    paramtype = "light",
    paramtype2 = "leveled",
    leveled = 8,
    sunlight_propagates = true,
    drawtype = "nodebox",
    node_placement_prediction = "",
    buildable_to = true,
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

minetest.register_craftitem("fl_topsoil:flint", {
    descripion = "flint",
    inventory_image = "farlands_flint.png",
})

minetest.register_node("fl_topsoil:gravel", {
    description = "gravel",
    tiles = {"farlands_gravel.png"},
    drop = {
        max_items = 1,
        items = {
            {items = {"fl_topsoil:flint"}, rarity = 14},
            {items = {"fl_topsoil:gravel"}}
        }
    },
    sounds = fl_topsoil.sounds.gravel(),
    _dungeon_loot = {chance = 0.8, count = {4, 32}},
    groups = {dig_sand = 3, falling_node = 1},
})

minetest.register_node("fl_topsoil:permafrost", {
    description = "permafrost",
    tiles = {"farlands_permafrost.png"},
    groups = {dig_stone = 2},
})

minetest.register_node("fl_topsoil:permafrost_with_stones", {
    description = "permafrost",
    tiles = {
        "farlands_permafrost.png^farlands_stones.png",
        "farlands_permafrost.png",
        "farlands_permafrost.png^([combine:16x4:0,1=(farlands_stones.png\\^[transformR180))"
    },
    groups = {dig_stone = 2},
})
for i=1, 3 do
    minetest.register_node("fl_topsoil:sea_grass_" .. i, {
        description = "sea grass",
        drawtype = "plantlike_rooted",
        paramtype = "light",
        paramtype2 = "meshoptions",
        tiles = {"farlands_sand.png"},
        special_tiles = {"[combine:16x16:0," .. 10 - 3*i .. "=farlands_sea_grass.png"},
        inventory_image = "[combine:16x16:0," .. 10 - 3*i .. "=farlands_sea_grass.png",
        wield_image = "[combine:16x16:0," .. 10 - 3*i .. "=farlands_sea_grass.png",
        node_dig_prediction = "fl_stone:sand",
        node_placement_prediction = "",
        on_place = function(itemstack, placer, pointed_thing)
            if pointed_thing.type ~= "node" then return end
            if minetest.get_node_or_nil(pointed_thing.under)
            and minetest.get_node_or_nil(pointed_thing.under).name == "fl_stone:sand" then
                minetest.set_node(pointed_thing.under, {name = "fl_topsoil:sea_grass_" .. i})
            end
        end,
        after_destruct  = function(pos, oldnode)
            minetest.set_node(pos, {name = "fl_stone:sand"})
        end,
        groups = {not_in_creative_inventory = 1, dig_sand = 3},
    })
end

minetest.register_alias("fl_stone:dirt", "fl_topsoil:dirt")
minetest.register_alias("fl_terrain:dirt", "fl_topsoil:dirt")
minetest.register_alias("fl_terrain:dirt_with_grass", "fl_topsoil:dirt_with_grass")
minetest.register_alias("fl_terrain:sand", "fl_topsoil:sand")
minetest.register_alias("fl_terrain:ice", "fl_topsoil:ice")
minetest.register_alias("fl_terrain:condensed_ice", "fl_topsoil:condensed_ice")
minetest.register_alias("fl_terrain:snow_block", "fl_topsoil:snow_block")
minetest.register_alias("fl_terrain:snow", "fl_topsoil:snow")