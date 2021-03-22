--[[
minetest.register_node("fl_terrain:desert_stone", {
    description = "Desert Stone",
    tiles = {"farlands_desert_stone.png"},
    groups = {oddly_breakable_by_hand = 3},
})
--]]

--break

local function create_stone_types(name, groups)
    local gp = groups or {oddly_breakable_by_hand = 3}

    minetest.register_node("fl_terrain:" .. name .. "_rubble", {
        description = name .. " rubble",
        tiles = {"farlands_" .. name .. "_rubble.png"},
        groups = gp,
    })
    minetest.register_node("fl_terrain:" .. name, {
        description = name,
        tiles = {"farlands_" .. name .. ".png"},
        drop = "fl_terrain:" .. name .. "_rubble",
        groups = gp,
    })
    minetest.register_node("fl_terrain:" .. name .. "_block", {
        description = name .. " block",
        tiles = {"farlands_" .. name .. "_block.png"},
        groups = gp,
    })
    minetest.register_node("fl_terrain:" .. name .. "_brick", {
        description = name .. " brick",
        tiles = {"farlands_" .. name .. "_brick.png"},
        groups = gp,
    })

end

create_stone_types("stone")
create_stone_types("ors")
create_stone_types("tuff")
create_stone_types("basalt")
create_stone_types("gneiss")
create_stone_types("desert_stone")