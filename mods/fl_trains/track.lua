minetest.register_node("fl_trains:straight_track", {
    description = "straight track",
    paramtype = "light",
    paramtype2 = "facedir",
    drawtype = "mesh",
    mesh = "farlands_straight.obj",
    tiles = {"farlands_rail.png", "farlands_ties.png"},
    groups = {oddly_breakable_by_hand = 3},--, not_in_creative_inventory = 1},
    selection_box = {
        type = "fixed",
        fixed = {-0.5,-0.5,-0.5,0.5,-0.475,0.5},
    },
    collision_box = {
        type = "fixed",
        fixed = {0,0,0,0,0,0},
    },
})

minetest.register_node("fl_trains:curve_right_track", {
    description = "right curve track",
    paramtype = "light",
    paramtype2 = "facedir",
    drawtype = "mesh",
    mesh = "farlands_curved_right.obj",
    tiles = {"farlands_ties.png", "farlands_rail.png", },
    groups = {oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
    selection_box = {
        type = "fixed",
        fixed = {-0.5,-0.5,-0.5,0.5,-0.475,0.5},
    },
    collision_box = {
        type = "fixed",
        fixed = {0,0,0,0,0,0},
    },
})

minetest.register_node("fl_trains:curve_left_track", {
    description = "left curve track",
    paramtype = "light",
    paramtype2 = "facedir",
    drawtype = "mesh",
    mesh = "farlands_curved_left.obj",
    tiles = {"farlands_ties.png", "farlands_rail.png", },
    groups = {oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
    selection_box = {
        type = "fixed",
        fixed = {-0.5,-0.5,-0.5,0.5,-0.475,0.5},
    },
    collision_box = {
        type = "fixed",
        fixed = {0,0,0,0,0,0},
    },
})

minetest.register_node("fl_trains:straight_45_track", {
    description = "45 degree straight track",
    paramtype = "light",
    paramtype2 = "facedir",
    drawtype = "mesh",
    mesh = "farlands_straight_45.obj",
    tiles = {"farlands_ties.png", "farlands_rail.png", },
    groups = {oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
    selection_box = {
        type = "fixed",
        fixed = {-0.5,-0.5,-0.5,0.5,-0.475,0.5},
    },
    collision_box = {
        type = "fixed",
        fixed = {0,0,0,0,0,0},
    },
})

minetest.register_node("fl_trains:crossing_track", {
    description = "corssing track",
    paramtype = "light",
    paramtype2 = "facedir",
    drawtype = "mesh",
    mesh = "farlands_crossing.obj",
    tiles = {"farlands_ties.png", "farlands_rail.png", },
    groups = {oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
    selection_box = {
        type = "fixed",
        fixed = {-0.5,-0.5,-0.5,0.5,-0.475,0.5},
    },
    collision_box = {
        type = "fixed",
        fixed = {0,0,0,0,0,0},
    },
})

minetest.register_node("fl_trains:switch_right_track", {
    description = "switch right track",
    paramtype = "light",
    paramtype2 = "facedir",
    drawtype = "mesh",
    mesh = "farlands_switch_right.obj",
    tiles = {"farlands_ties.png", "farlands_rail.png", },
    groups = {oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
    selection_box = {
        type = "fixed",
        fixed = {-0.5,-0.5,-0.5,0.5,-0.475,0.5},
    },
    collision_box = {
        type = "fixed",
        fixed = {0,0,0,0,0,0},
    },
})

minetest.register_node("fl_trains:switch_left_track", {
    description = "switch left track",
    paramtype = "light",
    paramtype2 = "facedir",
    drawtype = "mesh",
    mesh = "farlands_switch_left.obj",
    tiles = {"farlands_ties.png", "farlands_rail.png", },
    groups = {oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
    selection_box = {
        type = "fixed",
        fixed = {-0.5,-0.5,-0.5,0.5,-0.475,0.5},
    },
    collision_box = {
        type = "fixed",
        fixed = {0,0,0,0,0,0},
    },
})

minetest.register_node("fl_trains:straight_rise_track", {
    description = "straight rise track",
    paramtype = "light",
    paramtype2 = "facedir",
    drawtype = "mesh",
    mesh = "farlands_straight_rise.obj",
    tiles = {"farlands_rail.png", "farlands_ties.png", },
    groups = {oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
    selection_box = {
        type = "fixed",
        fixed = {-0.5,-0.5,-0.5,0.5,-0.475,0.5},
    },
    collision_box = {
        type = "fixed",
        fixed = {0,0,0,0,0,0},
    },
})