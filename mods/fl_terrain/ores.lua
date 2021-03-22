local function register_ore(name, block_groups)
    local gp = block_groups or {oddly_breakable_by_hand = 3}

    minetest.register_craftitem("fl_terrain:" .. name .. "_ore", {
        description = name .. " ore",
        inventory_image = "farlands_" .. name .. "_ore.png",
    })
    minetest.register_node("fl_terrain:" .. name .. "_block", {
        description = name .. " block",
        tiles = {"farlands_" .. name .. "_block.png"},
        groups = gp,
    })

    local base_material = {
        "stone",
        "ors",
        "tuff",
        "desert_stone"
    }
    for _, bm in pairs(base_material) do
        minetest.register_node("fl_terrain:" .. name .. "_in_" .. bm, {
            description = name .. " in " .. bm,
            tiles = {"farlands_" .. bm .. ".png^farlands_" .. name .. "_overlay.png"},
            groups = minetest.registered_nodes["fl_terrain:" .. bm]["groups"],
            drop = "fl_terrain:" .. name .. "_ore",
        })
    end
end

--mithite
--[[
minetest.register_craftitem("fl_terrain:mithite_ore", {
    description = "mithite ore",
    inventory_image = "farlands_mithite_ore.png"
})

local tiles = minetest.registered_nodes["fl_terrain:stone"]["tiles"]
minetest.register_node("fl_terrain:mithite_in_stone", {
    description = "mithite ore in stone",
    tiles = {tiles[1] .. "^farlands_mithite_overlay.png"},
    groups = {oddly_breakable_by_hand = 3},
    drop = "fl_terrain:mithite_ore",
})
--]]
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