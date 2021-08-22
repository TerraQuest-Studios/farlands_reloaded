--seed: me

--258, 35, -742
minetest.register_decoration({
    name = "fl_trees:acacia_tree",
    deco_type = "schematic",
    place_on = "fl_topsoil:savannah_dirt_with_grass",
    sidelen = 16,
    noise_params = {
        offset = 0,
        scale = 0.002,
        spread = {x = 500, y = 500, z = 500},
        seed = 2,
        octaves = 3,
        persist = 0.66,
    }, --?
    biomes = {"savannah"},
    y_max = 300,
    y_min = 4,
    place_offset_y = 1,
    schematic = minetest.get_modpath("fl_trees") .. "/schems/acacia_tree_" .. math.random(5) .. ".mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
})

--2015, 44, -258
minetest.register_decoration({
    name = "fl_trees:baobab_tree",
    deco_type = "schematic",
    place_on = "fl_stone:sand",
    sidelen = 16,
    fill_ratio = 0.0001,
    biomes = {"sand"},
    y_max = 300,
    y_min = 4,
    place_offset_y = 1,
    schematic = minetest.get_modpath("fl_trees") .. "/schems/baobab_tree_" .. math.random(5) .. ".mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
})

--41, 36, -170
minetest.register_decoration({
    name = "fl_trees:apple_tree_1",
    deco_type = "schematic",
    place_on = "fl_topsoil:dirt_with_grass",
    sidelen = 16,
    fill_ratio = 0.03,
    biomes = {"deciduousforest"},
    y_max = 300,
    y_min = 4,
    place_offset_y = 1,
    schematic = minetest.get_modpath("fl_trees") .. "/schems/apple_tree_1.mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
})

--41, 36, -170
minetest.register_decoration({
    name = "fl_trees:apple_tree_4",
    deco_type = "schematic",
    place_on = "fl_topsoil:dirt_with_grass",
    sidelen = 16,
    fill_ratio = 0.03,
    biomes = {"deciduousforest"},
    y_max = 300,
    y_min = 4,
    place_offset_y = 1,
    schematic = minetest.get_modpath("fl_trees") .. "/schems/apple_tree_4.mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
})

minetest.register_decoration({
    name = "fl_trees:aspen_tree",
    deco_type = "schematic",
    place_on = "fl_topsoil:dirt_with_grass",
    sidelen = 16,
    fill_ratio = 0.0001,
    biomes = {"grassland", "snowy_grassland"},
    y_max = 300,
    y_min = 4,
    place_offset_y = 1,
    schematic = minetest.get_modpath("fl_trees") .. "/schems/aspen_tree_" .. math.random(5) .. ".mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
})

minetest.register_decoration({
    name = "fl_trees:pine_tree_tiaga",
    deco_type = "schematic",
    place_on = "fl_topsoil:dirt_with_snow",
    sidelen = 16,
    fill_ratio = 0.1,
    biomes = {"taiga"},
    y_max = 300,
    y_min = 4,
    place_offset_y = 1,
    schematic = minetest.get_modpath("fl_trees") .. "/schems/pine_tree_" .. math.random(5) .. ".mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
})

minetest.register_decoration({
    name = "fl_trees:pine_tree_coniferousforest",
    deco_type = "schematic",
    place_on = "fl_topsoil:dirt_with_grass",
    sidelen = 16,
    fill_ratio = 0.01,
    biomes = {"coniferousforest"},
    y_max = 300,
    y_min = 4,
    place_offset_y = 1,
    schematic = minetest.get_modpath("fl_trees") .. "/schems/pine_tree_" .. math.random(5) .. ".mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
})

minetest.register_decoration({
    name = "fl_trees:palm_tree",
    deco_type = "schematic",
    place_on = "fl_stone:sand",
    spawn_by = "fl_liquids:water_source",
    sidelen = 16,
    fill_ratio = 0.001,
    biomes = {"savannah_ocean", "sand_ocean", "desert_ocean"},
    y_max = 1,
    y_min = 1,
    place_offset_y = 1,
    schematic = minetest.get_modpath("fl_trees") .. "/schems/palm_tree_" .. math.random(5) .. ".mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
})