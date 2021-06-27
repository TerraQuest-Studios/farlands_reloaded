local function register_ore(name, block_groups)
    local gp = block_groups or {oddly_breakable_by_hand = 3}

    minetest.register_craftitem("fl_ores:" .. name .. "_ore", {
        description = name .. " ore",
        inventory_image = "farlands_" .. name .. "_ore.png",
    })
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
        "desert_stone"
    }
    for _, bm in pairs(base_material) do
        local sgp = table.copy(minetest.registered_nodes["fl_stone:" .. bm]["groups"])
        sgp.stairable, sgp.wallable = nil, nil
        minetest.register_node("fl_ores:" .. name .. "_in_" .. bm, {
            description = name .. " in " .. bm,
            tiles = {"farlands_" .. bm .. ".png^farlands_" .. name .. "_overlay.png"},
            groups = sgp,
            drop = "fl_ores:" .. name .. "_ore",
        })

        minetest.register_alias("fl_terrain:" .. name .. "_in_" .. bm, "fl_ores:" .. name .. "_in_" .. bm)
    end
end

register_ore("mithite")
register_ore("coal")
register_ore("iron")
register_ore("gold")
register_ore("diamond")
register_ore("copper")

--replace gold, dia? block textures
--what to do with oher ore blocks?
--deal with iron being on stone background
--change mithire ore overlay

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