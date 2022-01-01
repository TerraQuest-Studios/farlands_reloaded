local function register_ore(name, ingot_toggle, block_groups)
    local gp = block_groups or {oddly_breakable_by_hand = 3}

    minetest.register_craftitem("fl_ores:" .. name .. "_ore", {
        description = name .. " ore",
        inventory_image = "farlands_" .. name .. "_ore.png",
    })
    if ingot_toggle ~= false then
        minetest.register_craftitem("fl_ores:" .. name .. "_ingot", {
            description = name .. " ingot",
            inventory_image = "farlands_" .. name .. "_ingot.png",
        })
    end
    minetest.register_node("fl_ores:" .. name .. "_block", {
        description = name .. " block",
        tiles = {"farlands_" .. name .. "_block.png"},
        groups = gp,
    })

    minetest.register_alias("fl_terrain:" .. name .. "_ore", "fl_ores:" .. name .. "_ore")
    minetest.register_alias("fl_terrain:" .. name .. "_block", "fl_ores:" .. name .. "_block")

    local base_material = {
        "stone",
        "ors",
        "tuff",
        "desert_stone",
        "savannah"
    }
    for _, bm in pairs(base_material) do
        local sgp = table.copy(minetest.registered_nodes["fl_stone:" .. bm]["groups"])
        sgp.stairable, sgp.wallable = nil, nil
        local desc = string.gsub(bm, "_", " ")
        minetest.register_node("fl_ores:" .. name .. "_in_" .. bm, {
            description = name .. " in " .. desc,
            tiles = {"farlands_" .. bm .. ".png^farlands_" .. name .. "_overlay.png"},
            sounds = fl_stone.sounds.stone(),
            groups = sgp,
            drop = "fl_ores:" .. name .. "_ore",
        })

        minetest.register_alias("fl_terrain:" .. name .. "_in_" .. bm, "fl_ores:" .. name .. "_in_" .. bm)
    end
end


register_ore("coal", false)
register_ore("iron")
register_ore("copper")
register_ore("tin")
register_ore("gold")
register_ore("diamond", false)
register_ore("mithite", false)

--bronze block+ingot
minetest.register_craftitem("fl_ores:bronze_ingot", {
    description = "bronze ingot",
    inventory_image = "farlands_bronze_ingot.png"
})
minetest.register_node("fl_ores:bronze_block", {
    description = "bronze block",
    tiles = {"farlands_bronze_block.png"},
    groups = {oddly_breakable_by_hand = 3},
})

--crafts
minetest.register_craft({
    output = "fl_ores:coal_block",
    recipe = {
        {"fl_ores:coal_ore", "fl_ores:coal_ore", "fl_ores:coal_ore"},
        {"fl_ores:coal_ore", "fl_ores:coal_ore", "fl_ores:coal_ore"},
        {"fl_ores:coal_ore", "fl_ores:coal_ore", "fl_ores:coal_ore"},
    }
})

minetest.register_craft({
    output = "fl_ores:diamond_block",
    recipe = {
        {"fl_ores:diamond_ore", "fl_ores:diamond_ore", "fl_ores:diamond_ore"},
        {"fl_ores:diamond_ore", "fl_ores:diamond_ore", "fl_ores:diamond_ore"},
        {"fl_ores:diamond_ore", "fl_ores:diamond_ore", "fl_ores:diamond_ore"},
    }
})

local groups = table.copy(minetest.registered_items["fl_ores:coal_ore"].groups)
groups.fuel = 1
minetest.override_item("fl_ores:coal_ore",{
    groups = groups
})
groups = table.copy(minetest.registered_items["fl_ores:coal_block"].groups)
groups.fuel = 1
minetest.override_item("fl_ores:coal_block",{
    groups = groups
})

minetest.register_craft({
    type = "fuel",
    recipe = "fl_ores:coal_ore",
    burntime = 41,
})

minetest.register_craft({
    type = "fuel",
    recipe = "fl_ores:coal_block",
    burntime = 370,
})

if minetest.get_modpath("i3") then
    local base_material = {"stone", "ors", "tuff", "desert_stone", "savannah"}
    local ore = {"iron", "copper", "tin", "gold", "diamond", "mithite"}
    for _, mat in pairs(base_material) do
        i3.compress("fl_ores:coal_in_" .. mat, {
            replace = "coal",
            by = ore
        })
    end

    ore[#ore] = nil
    i3.compress("fl_ores:mithite_block", {
        replace = "mithite",
        by = ore
    })
end