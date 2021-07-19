local function create_sand_types(name, rgroups, sgroups, blgroups, brgroups)
    local rgp = rgroups or {oddly_breakable_by_hand = 3, falling_node = 1, sand = 1}
    local sgp = sgroups or {oddly_breakable_by_hand = 3, stairable = 1, sandlike = 1}
    local blgp = blgroups or {oddly_breakable_by_hand = 3, stairable = 1, sandlike = 1}
    local brgp = brgroups or {oddly_breakable_by_hand = 3, stairable = 1, sandlike = 1}
    local desc = string.gsub(name, "_", " ")

    --node registration
    minetest.register_node("fl_stone:" .. name, {
        description = desc,
        tiles = {"farlands_" .. name .. ".png"},
        groups = rgp,
    })
    minetest.register_node("fl_stone:" .. name .. "stone", {
        description = desc .. "stone",
        tiles = {"farlands_" .. name .. "stone.png"},
        groups = sgp,
    })
    minetest.register_node("fl_stone:" .. name .. "stone_block", {
        description = desc .. " stone block",
        tiles = {"farlands_" .. name .. "stone_block.png"},
        groups = blgp,
    })
    minetest.register_node("fl_stone:" .. name .. "stone_brick", {
        description = desc .. "stone brick",
        paramtype2 = "facedir",
        place_param2 = 0,
        tiles = {"farlands_" .. name .. "stone_brick.png^[transformR180"},
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

create_sand_types("sand")
create_sand_types("silver_sand")
create_sand_types("desert_sand")

