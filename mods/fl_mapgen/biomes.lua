--layers (broken)
minetest.register_biome({
    name = "ors",
    node_filler = "fl_stone:ors",
    node_stone = "fl_stone:ors",
    node_water = "air",
    node_river_water = "air",
    node_cave_liquid = "air",
    vertical_blend = 5,
    y_min = -150,
    y_max = -50,
    heat_point = 100,
    humidity_point = 0,
})

minetest.register_biome({
    name = "tuff",
    node_filler = "fl_stone:tuff",
    node_stone = "fl_stone:tuff",
    node_water = "air",
    node_river_water = "air",
    node_cave_liquid = "air",
    vertical_blend = 5,
    y_min = -300,
    y_max = -150,
    heat_point = 100,
    humidity_point = 0,
})