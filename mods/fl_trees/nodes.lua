local function tree_nodes(name, tgroup, lgroup)
    local tgp = tgroup or {oddly_breakable_by_hand = 3, tree = 1, trunk = 1}
    local lgp = lgroup or {oddly_breakable_by_hand = 3, tree = 1, leaf = 1}

    minetest.register_node("fl_trees:" .. name .. "_trunk", {
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
end

tree_nodes("acacia")
tree_nodes("apple")
tree_nodes("aspen")
tree_nodes("pine")