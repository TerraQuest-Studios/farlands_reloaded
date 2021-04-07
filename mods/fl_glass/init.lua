minetest.register_node("fl_glass:connected_glass", {
    description = "connected glass",
    drawtype = "glasslike_framed",
    tiles = {"farlands_glass.png", "farlands_glass_detail.png"},
    paramtype = "light",
    paramtype2 = "glasslikeliquidlevel",
    sunlight_propagates = true,
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_node("fl_glass:framed_glass", {
    description = "framed glass",
    drawtype = "glasslike",
    tiles = {"farlands_glass.png", "farlands_glass_detail.png"},
    paramtype = "light",
    paramtype2 = "glasslikeliquidlevel",
    sunlight_propagates = true,
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_alias("fl_glass:glass_connected", "fl_glass:connected_glass")
minetest.register_alias("fl_glass:glass_framed", "fl_glass:framed_glass")

--make colored glass, probably need to make dyes mod

minetest.register_node("fl_glass:tinted_connected_glass", {
    description = "tinted connected glass",
    drawtype = "glasslike_framed",
    tiles = {"farlands_glass.png", "farlands_glass_sheet.png^farlands_glass_detail.png"},
    paramtype = "light",
    paramtype2 = "color",
    sunlight_propagates = true,
    use_texture_alpha = "blend",
    palette = "farlands_palette.png",
    groups = {oddly_breakable_by_hand = 3},
    preserve_metadata = function(pos, oldnode, oldmeta, drops)
        drops[1]:get_meta():set_string("description", fl_dyes.dyes[oldnode.param2 + 1][2] .. " tinted connected glass")
    end,
})

minetest.register_node("fl_glass:tinted_framed_glass", {
    description = "tinted framed glass",
    drawtype = "glasslike",
    tiles = {"farlands_glass_sheet.png^farlands_glass.png", "farlands_glass_detail.png"},
    paramtype = "light",
    paramtype2 = "color",
    sunlight_propagates = true,
    use_texture_alpha = "blend",
    palette = "farlands_palette.png",
    groups = {oddly_breakable_by_hand = 3},
    preserve_metadata = function(pos, oldnode, oldmeta, drops)
        drops[1]:get_meta():set_string("description", fl_dyes.dyes[oldnode.param2 + 1][2] .. " tinted framed glass")
    end,
})

for counter, dye in pairs(fl_dyes.dyes) do
    local out_item = ItemStack(minetest.itemstring_with_palette("fl_glass:tinted_connected_glass", counter - 1))
    out_item:get_meta():set_string("description", fl_dyes.dyes[counter][2] .. " tinted connected glass")
    minetest.register_craft({
        output = out_item:to_string(),
        type = "shapeless",
        recipe = {
            "fl_glass:connected_glass",
            "fl_dyes:" .. dye[1] .. "_dye"
        },
    })
end

for counter, dye in pairs(fl_dyes.dyes) do
    local out_item = ItemStack(minetest.itemstring_with_palette("fl_glass:tinted_framed_glass", counter - 1))
    out_item:get_meta():set_string("description", fl_dyes.dyes[counter][2] .. " tinted framed glass")
    minetest.register_craft({
        output = out_item:to_string(),
        type = "shapeless",
        recipe = {
            "fl_glass:framed_glass",
            "fl_dyes:" .. dye[1] .. "_dye"
        },
    })
end