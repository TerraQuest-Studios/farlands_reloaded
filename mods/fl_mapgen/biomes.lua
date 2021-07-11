--vertical blend (broken)
minetest.register_biome({
    name = "grassland",
    node_top = "fl_topsoil:dirt_with_grass",
    depth_top = 1,
    node_filler = "fl_topsoil:dirt",
    depth_filler = 3,
    node_riverbed = "fl_topsoil:sand",
    depth_riverbed = 2,
    node_dungeon = "fl_stone:stone_rubble",
    node_dungeon_stair = "fl_stone:stone_rubble_stair",
    y_max = 300,
    y_min = 4,
    heat_point = 50,
    humidity_point = 50,
})

minetest.register_biome({
    name = "grassland_ocean",
    node_top = "fl_topsoil:sand",
    depth_top = 1,
    node_filler = "fl_topsoil:sand",
    depth_filler = 3,
    node_riverbed = "fl_topsoil:sand",
    depth_riverbed = 2,
    node_dungeon = "fl_stone:stone_rubble",
    node_dungeon_stair = "fl_stone:stone_rubble_stair",
    y_max = 3,
    y_min = -31,
    heat_point = 50,
    humidity_point = 50,
})

minetest.register_biome({
    name = "ors",
    node_filler = "fl_stone:ors",
    node_stone = "fl_stone:ors",
    node_dungeon = "fl_stone:ors",
    node_dungeon_stair = "fl_stone:ors_stair",
    node_water = "air",
    node_river_water = "air",
    node_cave_liquid = "air",
    y_min = -150,
    --[[
        this should be ranges -50 to -150, however this in reality ends up being -113 to -150,
        -32 was chosen based off https://forum.minetest.net/viewtopic.php?p=293354#p293354
        -34 works, but -40 does not. ironically the tuff biome of -150 to -300 works as defined
    --]]
    y_max = -32,
    vertical_blend = 8,
    heat_point = 50,
    humidity_point = 50,
})

minetest.register_biome({
    name = "tuff",
    node_filler = "fl_stone:tuff",
    node_stone = "fl_stone:tuff",
    node_dungeon = "fl_stone:tuff_rubble",
    node_dungeon_stair = "fl_stone:tuff_rubble_stair",
    node_water = "air",
    node_river_water = "air",
    node_cave_liquid = "air",
    y_min = -300,
    y_max = -150,
    vertical_blend = 8,
    heat_point = 50,
    humidity_point = 50,
})