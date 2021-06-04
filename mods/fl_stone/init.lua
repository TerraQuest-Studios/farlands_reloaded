local modpath = minetest.get_modpath("fl_stone")
dofile(modpath .. "/other.lua")

local function create_stone_types(name, rgroups, sgroups, blgroups, brgroups)
    local rgp = rgroups or {oddly_breakable_by_hand = 3, stairable = 1, wallable = 1, stonelike = 1}
    local sgp = sgroups or {oddly_breakable_by_hand = 3, stairable = 1, wallable = 1, stonelike = 1, stone = 1}
    local blgp = blgroups or {oddly_breakable_by_hand = 3, stairable = 1, stonelike = 1}
    local brgp = brgroups or {oddly_breakable_by_hand = 3, stairable = 1, wallable = 1, stonelike = 1}
    local rn = "fl_stone:" .. name .. "_rubble"

    --node registration
    minetest.register_node("fl_stone:" .. name .. "_rubble", {
        description = name .. " rubble",
        tiles = {"farlands_" .. name .. "_rubble.png"},
        groups = rgp,
    })
    minetest.register_node("fl_stone:" .. name, {
        description = name,
        tiles = {"farlands_" .. name .. ".png"},
        --drop = "fl_stone:" .. name .. "_rubble",
        drop = {
            max_items = 1,
            items = {
                {items = {rn}}
            },
            stairs = {
                slab = rn .. "_slab",
                stair = rn .. "_stair",
                inner_stair = rn .. "_inner_stair",
                outer_stair = rn .. "_outer_stair",
            },
            walls = rn .. "_wall"
        },
        --this is to make tnt happy while this is used as a dummy flammable
        on_construct = function(pos) end,
        groups = sgp,
    })
    minetest.register_node("fl_stone:" .. name .. "_block", {
        description = name .. " block",
        tiles = {"farlands_" .. name .. "_block.png"},
        groups = blgp,
    })
    minetest.register_node("fl_stone:" .. name .. "_brick", {
        description = name .. " brick",
        tiles = {"farlands_" .. name .. "_brick.png"},
        groups = brgp,
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