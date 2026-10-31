core.register_craft({
    output = "fl_topsoil:condensed_ice",
    recipe = {
        {"fl_topsoil:ice", "fl_topsoil:ice"},
        {"fl_topsoil:ice", "fl_topsoil:ice"},
    }
})

core.register_craft({
    output = "fl_topsoil:snow_block",
    recipe = {
        {"fl_topsoil:snow", "fl_topsoil:snow", "fl_topsoil:snow"},
        {"fl_topsoil:snow", "", "fl_topsoil:snow"},
        {"fl_topsoil:snow", "fl_topsoil:snow", "fl_topsoil:snow"},
    }
})

core.register_craft({
    output = "fl_topsoil:snow 8",
    recipe = {{"fl_topsoil:snow_block",}}
})