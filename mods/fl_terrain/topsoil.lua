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
    description = "grass",
    tiles = {"farlands_ice.png"},
    groups = {oddly_breakable_by_hand = 3},
})