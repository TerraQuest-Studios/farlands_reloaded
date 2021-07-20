--vertical blend (broken), also need to limit ocean depth to -25
--main biomes
--grassland
minetest.register_biome({
    name = "grassland",
    node_top = "fl_topsoil:dirt_with_grass",
    depth_top = 1,
    node_filler = "fl_stone:dirt",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    node_dungeon = "fl_stone:stone_rubble",
    node_dungeon_alt = "fl_stone:mossy_stone_rubble",
    node_dungeon_stair = "fl_stone:stone_rubble_stair",
    node_stone = "fl_stone:stone",
    y_max = 300,
    y_min = 4,
    heat_point = 50,
    humidity_point = 35,
})

minetest.register_biome({
    name = "grassland_ocean",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_stone:sand",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    node_stone = "fl_stone:stone",
    node_dungeon = "fl_stone:stone_rubble",
    node_dungeon_alt = "fl_stone:mossy_stone_rubble",
    node_dungeon_stair = "fl_stone:stone_rubble_stair",
    y_max = 3,
    y_min = -31,
    heat_point = 50,
    humidity_point = 35,
})

--sand
minetest.register_biome({
    name = "sand",
    node_top = "fl_stone:sand",
    depth_top = 3,
    node_filler = "fl_stone:sandstone",
    depth_filler = 5,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    node_dungeon = "fl_stone:sandstone_brick",
    node_dungeon_alt = "fl_stone:sandstone_block",
    node_dungeon_stair = "fl_stone:sandstone_stair",
    node_stone = "fl_stone:desert_stone",
    y_max = 300,
    y_min = 4,
    heat_point = 60,
    humidity_point = 0,
})

minetest.register_biome({
    name = "sand_ocean",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_stone:sand",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    node_dungeon = "fl_stone:sandstone_brick",
    node_dungeon_alt = "fl_stone:sandstone_block",
    node_dungeon_stair = "fl_stone:sandstone_stair",
    node_stone = "fl_stone:desert_stone",
    y_max = 3,
    y_min = -31,
    heat_point = 60,
    humidity_point = 0,
})

--desert
minetest.register_biome({
    name = "desert",
    node_top = "fl_stone:desert_sand",
    depth_top = 3,
    node_filler = "fl_stone:desert_sandstone",
    depth_filler = 5,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    node_dungeon = "fl_stone:desert_sandstone_brick",
    node_dungeon_alt = "fl_stone:desert_sandstone_block",
    node_dungeon_stair = "fl_stone:desert_sandstone_stair",
    node_stone = "fl_stone:desert_stone",
    y_max = 300,
    y_min = 4,
    heat_point = 92,
    humidity_point = 16,
})

minetest.register_biome({
    name = "desert_ocean",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_stone:sand",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    node_dungeon = "fl_stone:desert_sandstone_brick",
    node_dungeon_alt = "fl_stone:desert_sandstone_block",
    node_dungeon_stair = "fl_stone:desert_sandstone_stair",
    node_stone = "fl_stone:desert_stone",
    y_max = 3,
    y_min = -31,
    heat_point = 92,
    humidity_point = 16,
})

--silver sand
minetest.register_biome({
    name = "silver_sand",
    node_top = "fl_stone:silver_sand",
    depth_top = 3,
    node_filler = "fl_stone:silver_sandstone",
    depth_filler = 5,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    node_dungeon = "fl_stone:silver_sandstone_brick",
    node_dungeon_alt = "fl_stone:silver_sandstone_block",
    node_dungeon_stair = "fl_stone:silver_sandstone_stair",
    node_stone = "fl_stone:desert_stone",
    y_max = 300,
    y_min = 4,
    heat_point = 40,
    humidity_point = 0,
})

minetest.register_biome({
    name = "silver_sand_ocean",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_stone:sand",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    node_dungeon = "fl_stone:silver_sandstone_brick",
    node_dungeon_alt = "fl_stone:silver_sandstone_block",
    node_dungeon_stair = "fl_stone:silver_sandstone_stair",
    node_stone = "fl_stone:silver_stone",
    y_max = 3,
    y_min = -31,
    heat_point = 40,
    humidity_point = 0,
})

--savannah
minetest.register_biome({
    name = "savannah",
    node_top = "fl_topsoil:savannah_dirt_with_grass",
    depth_top = 1,
    node_filler = "fl_topsoil:savannah_dirt",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    node_dungeon = "fl_stone:savannah_rubble",
    --node_dungeon_alt = "fl_stone:silver_sandstone_block",
    node_dungeon_stair = "fl_stone:savannah_rubble_stair",
    node_stone = "fl_stone:savannah",
    y_max = 300,
    y_min = 4,
    heat_point = 89,
    humidity_point = 42,
})

minetest.register_biome({
    name = "savannah_ocean",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_stone:sand",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    node_dungeon = "fl_stone:savannah_rubble",
    --node_dungeon_alt = "fl_stone:silver_sandstone_block",
    node_dungeon_stair = "fl_stone:savannah_rubble_stair",
    node_stone = "fl_stone:savannah",
    y_max = 3,
    y_min = -31,
    heat_point = 89,
    humidity_point = 42,
})

--taiga
minetest.register_biome({
    name = "taiga",
    node_dust = "fl_topsoil:snow",
    node_top = "fl_topsoil:dirt_with_snow",
    depth_top = 1,
    node_filler = "fl_topsoil:dirt",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    node_dungeon = "fl_stone:stone_brick",
    node_dungeon_alt = "fl_stone:stone_block",
    node_dungeon_stair = "fl_stone:stone_stair",
    node_stone = "fl_stone:stone",
    y_max = 300,
    y_min = 4,
    heat_point = 25,
    humidity_point = 70,
})

minetest.register_biome({
    name = "taiga_ocean",
    node_dust = "fl_topsoil:snow",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_stone:sand",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    node_dungeon = "fl_stone:stone_brick",
    node_dungeon_alt = "fl_stone:stone_block",
    node_dungeon_stair = "fl_stone:stone_stair",
    node_stone = "fl_stone:stone",
    y_max = 3,
    y_min = -31,
    heat_point = 25,
    humidity_point = 70,
})

--snowy grasland
minetest.register_biome({
    name = "snowy_grassland",
    node_dust = "fl_topsoil:snow",
    node_top = "fl_topsoil:dirt_with_snow",
    depth_top = 1,
    node_filler = "fl_topsoil:dirt",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    node_dungeon = "fl_stone:stone_rubble",
    node_dungeon_alt = "fl_stone:mossy_stone_ruble",
    node_dungeon_stair = "fl_stone:stone_rubble_stair",
    node_stone = "fl_stone:stone",
    y_max = 300,
    y_min = 4,
    heat_point = 20,
    humidity_point = 35,
})

minetest.register_biome({
    name = "snowy_grassland_ocean",
    node_dust = "fl_topsoil:snow",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_stone:sand",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    node_dungeon = "fl_stone:stone_rubble",
    node_dungeon_alt = "fl_stone:mosy_stone_rubble",
    node_dungeon_stair = "fl_stone:stone_rubble_stair",
    node_stone = "fl_stone:stone",
    y_max = 3,
    y_min = -31,
    heat_point = 20,
    humidity_point = 35,
})

--underground biome layers
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