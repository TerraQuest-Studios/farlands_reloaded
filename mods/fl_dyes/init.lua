fl_dyes = {}

fl_dyes.details = {
    version = 3,
    name = "fl_dyes",
    author = "wsor",
    license = "MIT",
}

fl_dyes.dyes = {
    {"white", "White", "#f3f3f3"},
    {"violet", "Violet", "#8821d6"},
    {"red", "Red", "#e72e2e"},
    {"pink", "Pink", "#f2a9a9"},
    {"orange", "Orange", "#eb752b"},
    {"magenta", "Magenta", "#ed57b3"},
    {"grey", "Grey", "#aaaaaa"},
    {"green", "Green", "#79ef2b"},
    {"dark_grey", "Dark Grey", "#717171"},
    {"dark_green", "Dark Green", "#44b811"},
    {"cyan", "Cyan", "#13d4dc"},
    {"brown", "Brown", "#8c5510"},
    {"blue", "Blue", "#1382dd"},
    {"black", "Black", "#4e4e4e"},
    {"yellow", "Yellow", "#f3f01f"},
}

--this exists for legacy reasons
--maybe should be aliased to terracotta?
minetest.register_node("fl_dyes:demo_node", {
    description = "dye test node",
    tiles = {"farlands_demo.png"},
    paramtype = "light",
    paramtype2 = "color",
    --sunlight_propagates = true,
    palette = "farlands_palette.png",
    groups = {dig_generic = 4, not_in_creative_inventory = 1},
    preserve_metadata = function(pos, oldnode, oldmeta, drops)
        drops[1]:get_meta():set_string("description", fl_dyes.dyes[oldnode.param2 + 1][2] .. " test_node")
    end,
})

for _, dye in pairs(fl_dyes.dyes) do
    minetest.register_craftitem("fl_dyes:" .. dye[1] .. "_dye", {
        description = dye[2] .. " dye",
        inventory_image = "farlands_" .. dye[1] .. "_dye.png",
        groups = {dye = 1},
    })
end

for counter, dye in pairs(fl_dyes.dyes) do
    local out_item = ItemStack(minetest.itemstring_with_palette("fl_dyes:demo_node", counter - 1))
    out_item:get_meta():set_string("description", fl_dyes.dyes[counter][2] .. " test_node")
    minetest.register_craft({
        output = out_item:to_string(),
        type = "shapeless",
        recipe = {
            "fl_dyes:demo_node",
            "fl_dyes:" .. dye[1] .. "_dye"
        },
    })
end

if minetest.get_modpath("i3") then
    local colors = {}
    for _, dye in pairs(fl_dyes.dyes) do
        if dye[1] ~= "red" then table.insert(colors, dye[1]) end
    end

    i3.compress("fl_dyes:red_dye", {
        replace = "red",
        by = colors
    })
end