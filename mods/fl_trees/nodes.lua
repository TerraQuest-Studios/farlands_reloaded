local function tree_nodes(name, tgroup, lgroup, pgroup)
    local tgp = tgroup or {oddly_breakable_by_hand = 3, wood_related = 1, tree = 1, trunk = 1}
    local lgp = lgroup or {oddly_breakable_by_hand = 3, wood_related = 1, tree = 1, leaf = 1}
    local pgp = pgroup or {oddly_breakable_by_hand = 3, wood_related = 1, plank = 1}

    minetest.register_node("fl_trees:" .. name .. "_trunk", {
        --nodes
        description = name .. " tree trunk",
        tiles = {
            "farlands_" .. name .. "_trunk_top.png",
            "farlands_" .. name .. "_trunk_top.png",
            "farlands_" .. name .. "_trunk.png"
        },
        paramtype2 = "facedir",
        groups = tgp,
        on_place = minetest.rotate_node
    })
    minetest.register_node("fl_trees:" .. name .. "_leaves", {
        description = name .. " leaves",
        drawtype = "allfaces_optional",
        paramtype = "light",
        tiles = {"farlands_" .. name .. "_leaves.png"},
        groups = lgp,
    })
    minetest.register_node("fl_trees:" .. name .. "_plank", {
        description = name .. " plank",
        paramtype2 = "facedir",
        --place_param2 = 0,
        tiles = {"farlands_" .. name .. "_planks.png"},
        groups = pgp,
        on_place = minetest.rotate_node
    })

    --crafts
    minetest.register_craft({
        output = "fl_trees:" .. name .. "_plank 4",
        recipe = {{"fl_trees:" .. name .. "_trunk",}}
    })
end

tree_nodes("acacia")
tree_nodes("apple")
tree_nodes("aspen")
tree_nodes("pine")
tree_nodes("spruce")

minetest.register_node("fl_trees:dead_aspen_leaves", {
    description = "dead aspen leaves",
    drawtype = "allfaces_optional",
    paramtype = "light",
    tiles = {"farlands_dead_aspen_leaves.png"},
    groups = {oddly_breakable_by_hand = 3, tree = 1, leaf = 1},
})