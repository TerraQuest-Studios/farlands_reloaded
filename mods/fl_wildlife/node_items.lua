minetest.register_craftitem("fl_wildlife:nametag", {
    description = "Name Tag",
    inventory_image = "farlands_nametag.png",
    --groups = {flammable = 2, nametag = 1},
})

--[[
local function v_item()
    local valuable = minetest.settings:get("fl_wildlife.trader.valuable")

    if not minetest.registered_items[valuable] then return "fl_wildlife:mithite_ore"
    else return valuable end
end

if v_item() == "fl_wildlife:mithite_ore" then
    minetest.register_craftitem("fl_wildlife:mithite_ore", {
        description = "mithite ore",
        inventory_image = "farlands_mithite_ore.png"
    })

    local tiles = minetest.registered_nodes["mapgen_stone"]["tiles"]
    minetest.register_node("fl_wildlife:mithite_in_stone", {
        description = "mithite ore in stone",
        tiles = {tiles[1] .. "^farlands_mithite_in_stone.png"},
        groups = {cracky = 3},
        drop = "fl_wildlife:mithite_ore",
        --sounds = default.node_sound_stone_defaults(),
    })

    minetest.register_ore({
        ore_type = "scatter",
        ore = "fl_wildlife:mithite_in_stone",
        wherein = "mapgen_stone",
        clust_scarcity = 30*30*30,
        clust_num_ores = 1,
        clust_size = 1,
        y_min = -32,
        y_max = 32,
    })
else
    minetest.register_alias("fl_wildlife:mithite_in_stone", "mapgen_stone")
    minetest.register_alias("fl_wildlife:mithite_ore", minetest.settings:get("fl_wildlife.trader.valuable"))
end
--]]