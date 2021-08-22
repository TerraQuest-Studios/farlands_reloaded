local modpath = minetest.get_modpath("fl_plantlife")

minetest.register_node("fl_plantlife:raw_mushroom_leaves", {
    description = "raw mushroom leaves",
    tiles = {"farlands_raw_mushroom_leaves.png"},
    groups = {oddly_breakable_by_hand = 3}
})

minetest.register_node("fl_plantlife:red_mushroom_leaves", {
    description = "red mushroom leaves",
    tiles = {"farlands_red_mushroom_leaves.png"},
    groups = {oddly_breakable_by_hand = 3}
})

minetest.register_node("fl_plantlife:brown_mushroom_leaves", {
    description = "brown mushroom leaves",
    tiles = {"farlands_brown_mushroom_leaves.png"},
    groups = {oddly_breakable_by_hand = 3}
})

minetest.register_node("fl_plantlife:mushroom_trunk", {
    description = "mushroom trunk",
    tiles = {"farlands_mushroom_trunk_top.png", "farlands_mushroom_trunk_top.png", "farlands_mushroom_trunk.png"},
    paramtype2 = "facedir",
    on_place = minetest.rotate_node,
    groups = {oddly_breakable_by_hand = 3}
})

minetest.register_node("fl_plantlife:red_mushroom", {
    description = "red mushroom",
    drawtype = "plantlike",
    paramtype = "light",
    inventory_image = "farlands_red_mushroom_plant.png",
    walkable = false,
    tiles = {"farlands_red_mushroom_plant.png"},
    selection_box = {
        type = "fixed",
        fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
    },
    _on_bonemeal = function(pos)
        if math.random(20) < 16 then return end
        minetest.remove_node(pos)
        minetest.place_schematic(
            {x=pos.x-2, y=pos.y, z=pos.z-2},
            modpath .. "/schems/red_mushroom_large.mts",
            "random",
            nil,
            false
        )
    end,
    groups = {oddly_breakable_by_hand = 3, plant = 1, flower = 1, potable = 1}
})

minetest.register_node("fl_plantlife:brown_mushroom", {
    description = "brown mushroom",
    drawtype = "plantlike",
    paramtype = "light",
    inventory_image = "farlands_brown_mushroom_plant.png",
    walkable = false,
    tiles = {"farlands_brown_mushroom_plant.png"},
    selection_box = {
        type = "fixed",
        fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
    },
    _on_bonemeal = function(pos)
        if math.random(20) < 16 then return end
        minetest.remove_node(pos)
        minetest.place_schematic(
            {x=pos.x-2, y=pos.y, z=pos.z-2},
            modpath .. "/schems/brown_mushroom_large.mts",
            "random",
            nil,
            false
        )
    end,
    groups = {oddly_breakable_by_hand = 3, plant = 1, flower = 1, potable = 1}
})