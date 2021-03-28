minetest.register_craft({
    output = "fl_terrain:condensed_ice",
    recipe = {
        {"fl_terrain:ice", "fl_terrain:ice"},
        {"fl_terrain:ice", "fl_terrain:ice"},
    }
})

minetest.register_craft({
    output = "fl_terrain:coal_block",
    recipe = {
        {"fl_terrain:coal_ore", "fl_terrain:coal_ore", "fl_terrain:coal_ore"},
        {"fl_terrain:coal_ore", "fl_terrain:coal_ore", "fl_terrain:coal_ore"},
        {"fl_terrain:coal_ore", "fl_terrain:coal_ore", "fl_terrain:coal_ore"},
    }
})

minetest.register_craft({
    output = "fl_terrain:diamond_block",
    recipe = {
        {"fl_terrain:diamond_ore", "fl_terrain:diamond_ore", "fl_terrain:diamond_ore"},
        {"fl_terrain:diamond_ore", "fl_terrain:diamond_ore", "fl_terrain:diamond_ore"},
        {"fl_terrain:diamond_ore", "fl_terrain:diamond_ore", "fl_terrain:diamond_ore"},
    }
})

minetest.register_craft({
    output = "fl_terrain:snow_block",
    recipe = {
        {"fl_terrain:snow", "fl_terrain:snow", "fl_terrain:snow"},
        {"fl_terrain:snow", "", "fl_terrain:snow"},
        {"fl_terrain:snow", "fl_terrain:snow", "fl_terrain:snow"},
    }
})

minetest.register_craft({
    output = "fl_terrain:snow 8",
    recipe = {{"fl_terrain:snow_block",}}
})