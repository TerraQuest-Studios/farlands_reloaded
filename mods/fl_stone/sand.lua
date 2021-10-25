local function create_sand_types(name, rgroups, sgroups, blgroups, brgroups)
    local rgp = rgroups or {dig_sand = 3, falling_node = 1, sand = 1}
    local sgp = sgroups or {dig_sand = 2, stairable = 1, sandlike = 1}
    local blgp = blgroups or {dig_sand = 1, stairable = 1, sandlike = 1}
    local brgp = brgroups or {dig_sand = 1, stairable = 1, sandlike = 1}
    local desc = string.gsub(name, "_", " ")

    --node registration
    minetest.register_node("fl_stone:" .. name, {
        description = desc,
        tiles = {"farlands_" .. name .. ".png"},
        sounds = fl_stone.sounds.sand(),
        groups = rgp,
    })
    minetest.register_node("fl_stone:" .. name .. "stone", {
        description = desc .. "stone",
        tiles = {"farlands_" .. name .. "stone.png"},
        sounds = fl_stone.sounds.stone(),
        groups = sgp,
    })
    minetest.register_node("fl_stone:" .. name .. "stone_block", {
        description = desc .. " stone block",
        tiles = {"farlands_" .. name .. "stone_block.png"},
        sounds = fl_stone.sounds.stone(),
        groups = blgp,
    })
    minetest.register_node("fl_stone:" .. name .. "stone_brick", {
        description = desc .. "stone brick",
        paramtype2 = "facedir",
        place_param2 = 0,
        tiles = {"farlands_" .. name .. "stone_brick.png^[transformR180"},
        sounds = fl_stone.sounds.stone(),
        groups = brgp,
    })

    --craft registration
    local sn = "fl_stone:" .. name
    local ssn = sn .. "stone"
    minetest.register_craft({
        output = ssn,
        recipe = {
            {sn, sn},
            {sn, sn},
        }
    })
    minetest.register_craft({
        output = "fl_stone:" .. name .. "stone_block",
        recipe = {
            {ssn, ssn, ssn},
            {ssn, ssn, ssn},
            {ssn, ssn, ssn},
        }
    })
    minetest.register_craft({
        output = "fl_stone:" .. name .. "stone_brick",
        recipe = {
            {ssn, ssn},
            {ssn, ssn},
        }
    })

    minetest.register_alias("fl_topsoil:" .. name, "fl_stone:" .. name)
end

local sand_types = {"sand", "silver_sand", "desert_sand"}

for _, type in pairs(sand_types) do
    create_sand_types(type)
end

if minetest.get_modpath("i3") then
    local types = {"", "stone", "stone_block", "stone_brick"}
    sand_types[#sand_types] = nil
    for _, type in pairs(types) do
        i3.compress("fl_stone:desert_sand" .. type, {
            replace = "desert_sand",
            by = sand_types
        })
    end
end

