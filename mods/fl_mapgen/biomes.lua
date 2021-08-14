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
    _sky_data = {
        sky = {
            sky_color={
                day_sky = "#01C7EC",
                night_sky = "#00FFFF",
                dawn_sky = "#00AAFF",
            },
        },
    }
})

minetest.register_biome({
    name = "grassland_ocean",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_stone:sand",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    vertical_blend = 3,
    node_stone = "fl_stone:stone",
    node_dungeon = "fl_stone:mossy_stone_rubble",
    node_dungeon_alt = "fl_stone:mossy_stone_rubble",
    node_dungeon_stair = "fl_stone:stone_rubble_stair",
    y_max = 3,
    y_min = -31,
    heat_point = 50,
    humidity_point = 35,
    _sky_data = {
        sky = {
            sky_color={
                day_sky = "#01C7EC",
                night_sky = "#00FFFF",
                dawn_sky = "#00AAFF",
            },
        },
    }
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
    _sky_data = {
        sky = {
            clouds = true,
            sky_color = {
                day_sky = "#AF8957",
                day_horizon = "#C4A883",
                dawn_sky = "#AF8957",
                dawn_horizon = "#C4A883",
                night_sky = "#00013F",
            }
        },
    }
})

minetest.register_biome({
    name = "sand_ocean",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_stone:sand",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    vertical_blend = 3,
    node_dungeon = "fl_stone:sandstone_brick",
    node_dungeon_alt = "fl_stone:sandstone_block",
    node_dungeon_stair = "fl_stone:sandstone_stair",
    node_stone = "fl_stone:desert_stone",
    y_max = 3,
    y_min = -31,
    heat_point = 60,
    humidity_point = 0,
    _sky_data = {
        sky = {
            clouds = true,
            sky_color = {
                day_sky = "#AF8957",
                day_horizon = "#C4A883",
                dawn_sky = "#AF8957",
                dawn_horizon = "#C4A883",
                night_sky = "#00013F",
            }
        },
    }
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
    _sky_data = {
        sky = {
            clouds = true,
            sky_color = {
                day_sky = "#AF8957",
                day_horizon = "#C4A883",
                dawn_sky = "#AF8957",
                dawn_horizon = "#C4A883",
                night_sky = "#00013F",
            }
        },
    }
})

minetest.register_biome({
    name = "desert_ocean",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_stone:sand",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    vertical_blend = 3,
    node_dungeon = "fl_stone:desert_sandstone_brick",
    node_dungeon_alt = "fl_stone:desert_sandstone_block",
    node_dungeon_stair = "fl_stone:desert_sandstone_stair",
    node_stone = "fl_stone:desert_stone",
    y_max = 3,
    y_min = -31,
    heat_point = 92,
    humidity_point = 16,
    _sky_data = {
        sky = {
            clouds = true,
            sky_color = {
                day_sky = "#AF8957",
                day_horizon = "#C4A883",
                dawn_sky = "#AF8957",
                dawn_horizon = "#C4A883",
                night_sky = "#00013F",
            }
        },
    }
})

--silver sand
minetest.register_biome({
    name = "silversand",
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
    _sky_data = {
        sky = {
            clouds = true,
            sky_color = {
                day_sky = "#AF8957",
                day_horizon = "#C4A883",
                dawn_sky = "#AF8957",
                dawn_horizon = "#C4A883",
                night_sky = "#00013F",
            }
        },
    }
})

minetest.register_biome({
    name = "silversand_ocean",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_stone:sand",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    vertical_blend = 3,
    node_dungeon = "fl_stone:silver_sandstone_brick",
    node_dungeon_alt = "fl_stone:silver_sandstone_block",
    node_dungeon_stair = "fl_stone:silver_sandstone_stair",
    node_stone = "fl_stone:silver_stone",
    y_max = 3,
    y_min = -31,
    heat_point = 40,
    humidity_point = 0,
    _sky_data = {
        sky = {
            clouds = true,
            sky_color = {
                day_sky = "#AF8957",
                day_horizon = "#C4A883",
                dawn_sky = "#AF8957",
                dawn_horizon = "#C4A883",
                night_sky = "#00013F",
            }
        },
    }
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
    _sky_data = {
        sky = {
            clouds = true,
            sky_color = {
                day_sky = "#AF8957",
                day_horizon = "#C4A883",
                dawn_sky = "#AF8957",
                dawn_horizon = "#C4A883",
                night_sky = "#00013F",
            }
        },
    }
})

minetest.register_biome({
    name = "savannah_ocean",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_stone:sand",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    vertical_blend = 3,
    node_dungeon = "fl_stone:savannah_rubble",
    --node_dungeon_alt = "fl_stone:silver_sandstone_block",
    node_dungeon_stair = "fl_stone:savannah_rubble_stair",
    node_stone = "fl_stone:savannah",
    y_max = 3,
    y_min = -31,
    heat_point = 89,
    humidity_point = 42,
    _sky_data = {
        sky = {
            clouds = true,
            sky_color = {
                day_sky = "#AF8957",
                day_horizon = "#C4A883",
                dawn_sky = "#AF8957",
                dawn_horizon = "#C4A883",
                night_sky = "#00013F",
            }
        },
    }
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
    _sky_data = {
        sky = {sky_color = {day_sky = "#5555FF"}},
    }
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
    vertical_blend = 3,
    node_dungeon = "fl_stone:stone_brick",
    node_dungeon_alt = "fl_stone:stone_block",
    node_dungeon_stair = "fl_stone:stone_stair",
    node_stone = "fl_stone:stone",
    y_max = 3,
    y_min = -31,
    heat_point = 25,
    humidity_point = 70,
    _sky_data = {
        sky = {sky_color = {day_sky = "#5555FF"}},
    }
})

--snowy grasland
minetest.register_biome({
    name = "snowygrassland",
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
    name = "snowygrassland_ocean",
    node_dust = "fl_topsoil:snow",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_stone:sand",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    vertical_blend = 3,
    node_dungeon = "fl_stone:stone_rubble",
    node_dungeon_alt = "fl_stone:mosy_stone_rubble",
    node_dungeon_stair = "fl_stone:stone_rubble_stair",
    node_stone = "fl_stone:stone",
    y_max = 3,
    y_min = -31,
    heat_point = 20,
    humidity_point = 35,
})

minetest.register_biome({
    name = "icy",
    node_dust = "fl_topsoil:snow_block",
    node_top = "fl_topsoil:ice",
    depth_top = 11,
    node_filler = "fl_topsoil:permafrost",
    depth_filler = 2,
    node_stone = "fl_topsoil:permafrost",
    node_water_top = "fl_topsoil:ice",
    depth_water_top = 1,
    node_river_water = "fl_topsoil:ice",
    node_riverbed = "fl_topsoil:gravel",
    depth_riverbed = 2,
    node_dungeon = "fl_topsoil:ice",
    node_dungeon_alt = "fl_topsoil:condensed_ice",
    node_dungeon_stair = "fl_topsoil:condensed_ice_stair",
    y_max = 300,
    y_min = 4,
    heat_point = 0,
    humidity_point = 73,
    _sky_data = {
        sky_color = {
            day_sky = "#c5b7ea",
            day_horizon = "#f0ecff",
            dawn_sky = "#bf9bb4",
            dawn_horizon = "#dec6d7",
            night_sky = "#5400ff",
            night_horizon = "#4f2a9b",
        }
    }
})

minetest.register_biome({
    name = "icy_ocean",
    node_dust = "fl_topsoil:snow_block",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_topsoil:gravel",
    depth_filler = 3,
    node_stone = "fl_topsoil:permafrost",
    node_water_top = "fl_topsoil:ice",
    depth_water_top = 1,
    node_river_water = "fl_topsoil:ice",
    node_riverbed = "fl_topsoil:gravel",
    depth_riverbed = 2,
    vertical_blend = 3,
    node_dungeon = "fl_topsoil:ice",
    node_dungeon_alt = "fl_topsoil:condensed_ice",
    node_dungeon_stair = "fl_topsoil:condensed_ice_stair",
    y_max = 3,
    y_min = -31,
    heat_point = 0,
    humidity_point = 73,
    _sky_data = {
        sky_color = {
            day_sky = "#c5b7ea",
            day_horizon = "#f0ecff",
            dawn_sky = "#bf9bb4",
            dawn_horizon = "#dec6d7",
            night_sky = "#5400ff",
            night_horizon = "#4f2a9b",
        }
    }
})

minetest.register_biome({
    name = "tundra",
    node_top = "fl_topsoil:permafrost_with_stones",
    depth_top = 1,
    node_filler = "fl_topsoil:permafrost",
    depth_filler = 11,
    node_river_water = "fl_topsoil:ice",
    node_riverbed = "fl_topsoil:gravel",
    depth_riverbed = 2,
    node_water_top = "fl_topsoil:ice",
    depth_water_top = 1,
    node_stone = "fl_stone:stone",
    node_dungeon = "fl_topsoil:permafrost",
    node_dungeon_alt = "fl_stone:basalt",
    node_dungeon_stair = "fl_stone:basalt_rubble_stair",
    y_max = 300,
    y_min = 4,
    heat_point = 0,
    humidity_point = 40,
    _sky_data = {
        sky_color = {
            day_sky = "#c5b7ea",
            day_horizon = "#f0ecff",
            dawn_sky = "#bf9bb4",
            dawn_horizon = "#dec6d7",
            night_sky = "#5400ff",
            night_horizon = "#4f2a9b",
        }
    }
})

minetest.register_biome({
    name = "tundra_ocean",
    node_top = "fl_topsoil:sand",
    depth_top = 1,
    node_filler = "fl_topsoil:gravel",
    depth_filler = 3,
    node_river_water = "fl_topsoil:ice",
    node_riverbed = "fl_topsoil:gravel",
    depth_riverbed = 2,
    node_water_top = "fl_topsoil:ice",
    depth_water_top = 1,
    vertical_blend = 3,
    node_stone = "fl_stone:stone",
    node_dungeon = "fl_topsoil:permafrost",
    node_dungeon_alt = "fl_stone:basalt",
    node_dungeon_stair = "fl_stone:basalt_rubble_stair",
    y_max = 300,
    y_min = 4,
    heat_point = 0,
    humidity_point = 40,
    _sky_data = {
        sky_color = {
            day_sky = "#c5b7ea",
            day_horizon = "#f0ecff",
            dawn_sky = "#bf9bb4",
            dawn_horizon = "#dec6d7",
            night_sky = "#5400ff",
            night_horizon = "#4f2a9b",
        }
    }
})

minetest.register_biome({
    name = "rainforest",
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
    heat_point = 86,
    humidity_point = 65,
})

minetest.register_biome({
    name = "rainforest_ocean",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_stone:sand",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    vertical_blend = 3,
    node_stone = "fl_stone:stone",
    node_dungeon = "fl_stone:mossy_stone_rubble",
    node_dungeon_alt = "fl_stone:mossy_stone_rubble",
    node_dungeon_stair = "fl_stone:stone_rubble_stair",
    y_max = 3,
    y_min = -31,
    heat_point = 86,
    humidity_point = 65,
})

minetest.register_biome({
    name = "deciduousforest",
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
    heat_point = 60,
    humidity_point = 68,
})

minetest.register_biome({
    name = "deciduousforest_ocean",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_stone:sand",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    vertical_blend = 3,
    node_stone = "fl_stone:stone",
    node_dungeon = "fl_stone:mossy_stone_rubble",
    node_dungeon_alt = "fl_stone:mossy_stone_rubble",
    node_dungeon_stair = "fl_stone:stone_rubble_stair",
    y_max = 3,
    y_min = -31,
    heat_point = 60,
    humidity_point = 68,
})

minetest.register_biome({
    name = "coniferousforest",
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
    heat_point = 45,
    humidity_point = 70,
})

minetest.register_biome({
    name = "coniferousforest_ocean",
    node_top = "fl_stone:sand",
    depth_top = 1,
    node_filler = "fl_stone:sand",
    depth_filler = 3,
    node_riverbed = "fl_stone:sand",
    depth_riverbed = 2,
    vertical_blend = 3,
    node_stone = "fl_stone:stone",
    node_dungeon = "fl_stone:mossy_stone_rubble",
    node_dungeon_alt = "fl_stone:mossy_stone_rubble",
    node_dungeon_stair = "fl_stone:stone_rubble_stair",
    y_max = 3,
    y_min = -31,
    heat_point = 45,
    humidity_point = 70,
})
--rainforest, deciduous, coniferous

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
    _sky_data = {
        sky = {
            clouds = false,
            sky_color = {
                day_sky = "#000000",
                day_horizon = "#000000",
                dawn_sky = "#000000",
                dawn_horizon = "#000000",
                night_sky = "#000000",
                night_horizon = "#000000",
                indoors = "#000000",
            }
        },
        sun = {
            visible = false,
            sunrise_visible = false,
        },
        moon = {
            visible = false,
        },
        stars = {
            visible = false,
        },
        clouds = {},
    }
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
    _sky_data = {
        sky = {
            clouds = false,
            sky_color = {
                day_sky = "#000000",
                day_horizon = "#000000",
                dawn_sky = "#000000",
                dawn_horizon = "#000000",
                night_sky = "#000000",
                night_horizon = "#000000",
                indoors = "#000000",
            }
        },
        sun = {
            visible = false,
            sunrise_visible = false,
        },
        moon = {
            visible = false,
        },
        stars = {
            visible = false,
        },
        clouds = {},
    }
})