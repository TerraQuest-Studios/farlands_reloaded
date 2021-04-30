local modpath = minetest.get_modpath("fl_stone")
dofile(modpath .. "/other.lua")

local function create_stone_types(name, groups)
    local gp = groups or {oddly_breakable_by_hand = 3}

    --node registration
    minetest.register_node("fl_stone:" .. name .. "_rubble", {
        description = name .. " rubble",
        tiles = {"farlands_" .. name .. "_rubble.png"},
        groups = gp,
    })
    minetest.register_node("fl_stone:" .. name, {
        description = name,
        tiles = {"farlands_" .. name .. ".png"},
        drop = "fl_terrain:" .. name .. "_rubble",
        groups = gp,
    })
    minetest.register_node("fl_stone:" .. name .. "_block", {
        description = name .. " block",
        tiles = {"farlands_" .. name .. "_block.png"},
        groups = gp,
    })
    minetest.register_node("fl_stone:" .. name .. "_brick", {
        description = name .. " brick",
        tiles = {"farlands_" .. name .. "_brick.png"},
        groups = gp,
    })

    --craft registration
    local coreN = "fl_stone:" .. name
    minetest.register_craft({
        output = "fl_stone:" .. name .. "_block",
        recipe = {
            {coreN, coreN, coreN},
            {coreN, coreN, coreN},
            {coreN, coreN, coreN},
        }
    })
    minetest.register_craft({
        output = "fl_stone:" .. name .. "_brick",
        recipe = {
            {coreN, coreN},
            {coreN, coreN},
        }
    })

    minetest.register_alias("fl_terrain:" .. name .. "_rubble", "fl_stone:" .. name .. "_rubble")
    minetest.register_alias("fl_terrain:" .. name, "fl_stone:" .. name)
    minetest.register_alias("fl_terrain:" .. name .. "_block", "fl_stone:" .. name .. "_block")
    minetest.register_alias("fl_terrain:" .. name .. "_brick", "fl_stone:" .. name .. "_brick")
end

create_stone_types("stone")
create_stone_types("ors")
create_stone_types("tuff")
create_stone_types("basalt")
create_stone_types("gneiss")
create_stone_types("desert_stone")