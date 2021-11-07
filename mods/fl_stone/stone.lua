local function create_stone_types(name, rgroups, sgroups, blgroups, brgroups)
    local rgp = rgroups or {dig_stone = 3, stairable = 1, wallable = 1, stonelike = 1}
    local sgp = sgroups or {dig_stone = 2, stairable = 1, wallable = 1, stonelike = 1, stone = 1}
    local blgp = blgroups or {dig_stone = 1, stairable = 1, stonelike = 1}
    local brgp = brgroups or {dig_stone = 1, stairable = 1, wallable = 1, stonelike = 1}
    local rn = "fl_stone:" .. name .. "_rubble"

    --node registration
    minetest.register_node("fl_stone:" .. name .. "_rubble", {
        description = name .. " rubble",
        tiles = {"farlands_" .. name .. "_rubble.png"},
        sounds = fl_stone.sounds.stone(),
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
        _dungeon_loot = {chance = math.random(0.1, 0.3), count = {4, 64}},
        --this is to make tnt happy while this is used as a dummy flammable
        on_construct = function(pos) end,
        sounds = fl_stone.sounds.stone(),
        groups = sgp,
    })
    minetest.register_node("fl_stone:" .. name .. "_block", {
        description = name .. " block",
        tiles = {"farlands_" .. name .. "_block.png"},
        sounds = fl_stone.sounds.stone(),
        groups = blgp,
    })
    minetest.register_node("fl_stone:" .. name .. "_brick", {
        description = name .. " brick",
        paramtype2 = "facedir",
        place_param2 = 0,
        tiles = {"farlands_" .. name .. "_brick.png"},
        sounds = fl_stone.sounds.stone(),
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

local stone_types = {"stone", "mossy_stone", "savannah", "ors", "tuff", "basalt", "gneiss", "desert_stone"}

for _, type in pairs(stone_types) do
    create_stone_types(type)
end

--granite, brown granite,

if minetest.get_modpath("i3") then
    local types = {"", "_rubble", "_block", "_brick"}
    stone_types[#stone_types] = nil
    for _, type in pairs(types) do
        i3.compress("fl_stone:desert_stone" .. type, {
            replace = "desert_stone",
            by = stone_types
        })
    end
end