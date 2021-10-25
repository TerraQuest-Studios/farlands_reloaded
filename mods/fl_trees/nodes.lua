minetest.register_craftitem("fl_trees:stick", {
    description = "stick",
    inventory_image = "farlands_stick.png",
    _dungeon_loot = {name = "fl_trees:stick", chance = 0.6, count = {3, 6}},
})

local function tree_nodes(name, tgroup, lgroup, pgroup)
    local tgp = tgroup or {dig_tree = 1, wood_related = 1, tree = 1, trunk = 1}
    local lgp = lgroup or {dig_tree = 3, wood_related = 1, tree = 1, leaf = 1}
    local pgp = pgroup or {dig_tree = 2, wood_related = 1, plank = 1, fenceable = 1, stairable = 1}
    local fgp = table.copy(pgp)
    fgp.stairable, fgp.fenceable, fgp.fence, fgp.not_in_creative_inventory = nil, nil, 1, 1

    minetest.register_node("fl_trees:" .. name .. "_trunk", {
        --nodes
        description = name .. " tree trunk",
        tiles = {
            "farlands_" .. name .. "_trunk_top.png",
            "farlands_" .. name .. "_trunk_top.png",
            "farlands_" .. name .. "_trunk.png"
        },
        paramtype2 = "facedir",
        sounds = fl_trees.sounds.wood(),
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
        place_param2 = 0,
        tiles = {"farlands_" .. name .. "_planks.png"},
        sounds = fl_trees.sounds.wood(),
        groups = pgp,
        on_place = minetest.rotate_node
    })
    minetest.register_node("fl_trees:" .. name .. "_plank_fence", {
        description = name .. " fence",
        paramtype = "light",
        drawtype = "nodebox",
        node_box = {
            type = "connected",
            fixed = {-1/8, -1/2, -1/8, 1/8, 1/2, 1/8},
            connect_front = {{-1/16, 3/16, -1/2, 1/16, 5/16, -1/8 }, {-1/16, -5/16, -1/2, 1/16, -3/16, -1/8 }},
            connect_left =  {{-1/2, 3/16, -1/16, -1/8, 5/16, 1/16}, {-1/2, -5/16, -1/16, -1/8, -3/16, 1/16}},
            connect_back =  {{-1/16, 3/16, 1/8, 1/16, 5/16, 1/2 }, {-1/16, -5/16, 1/8, 1/16, -3/16, 1/2 }},
            connect_right = {{ 1/8, 3/16, -1/16, 1/2, 5/16, 1/16}, { 1/8, -5/16, -1/16, 1/2, -3/16, 1/16}},
        },
        connects_to = {"group:fence", "group:wood_related"},
        tiles = {"farlands_" .. name .. "_planks.png"},
        sounds = fl_trees.sounds.wood(),
        groups = fgp,
    })

    --crafts
    minetest.register_craft({
        output = "fl_trees:" .. name .. "_plank 4",
        recipe = {{"fl_trees:" .. name .. "_trunk",}}
    })

    minetest.register_craft({
        output = "fl_trees:stick 4",
        recipe = {{"fl_trees:" .. name .. "_plank"}},
    })
end

minetest.register_node("fl_trees:dead_aspen_leaves", {
    description = "dead aspen leaves",
    drawtype = "allfaces_optional",
    paramtype = "light",
    tiles = {"farlands_dead_aspen_leaves.png"},
    groups = {dig_tree = 3, tree = 1, leaf = 1},
})

local wtypes = {"acacia", "aspen", "pine", "spruce", "yellow_ipe", "willow", "baobab", "palm", "jungletree", "apple"}

for _, wood in pairs(wtypes) do
    tree_nodes(wood)
end

if minetest.get_modpath("i3") then
    local types = {"plank", "trunk", "leaves"}
    wtypes[#wtypes] = nil
    for _, type in pairs(types) do
        i3.compress("fl_trees:apple_" .. type, {
            replace = "apple",
            by = wtypes
        })
    end
end