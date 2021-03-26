local modpath = minetest.get_modpath("fl_trees")

minetest.register_node("fl_trees:aspen_sapling", {
    description = "aspen sapling",
    drawtype = "plantlike",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = true,
    tiles = {"farlands_aspen_sapling.png"},
    groups = {oddly_breakable_by_hand = 3},
    on_timer = function(pos)
        minetest.remove_node(pos)
        minetest.place_schematic({x=pos.x-2, y=pos.y, z=pos.z-2}, modpath .. "/schems/aspen_tree_" .. math.random(5) .. ".mts", 0, nil, false)
    end,
    on_costruct = function(pos)
        minetest.remove_node(pos)
        minetest.get_node_timer(pos):start(20)
    end,
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then return end
        minetest.get_node_timer(pointed_thing.above):start(20)
        return minetest.item_place(itemstack, placer, pointed_thing)
    end,
    selection_box = {type = "fixed", fixed = {-0.2, -0.5, -0.2, 0.2, 0.5, 0.2}},
    collision_box = {type = "fixed", fixed = {-0.2, -0.5, -0.2, 0.2, 0.5, 0.2}}
})