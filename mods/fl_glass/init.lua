--one glass block is 16 panes
local cgroups = {"group:dig_generic","group:dig_sand","group:dig_stone",
                 "group:dig_glass","group:dig_tree","group:dig_snow",
                 "group:dig_dirt"}

--glass nodes
minetest.register_node("fl_glass:framed_glass", {
    description = "framed glass",
    drawtype = "glasslike",
    tiles = {"farlands_glass.png", "farlands_glass_detail.png"},
    paramtype = "light",
    paramtype2 = "glasslikeliquidlevel",
    sunlight_propagates = true,
    groups = {dig_glass = 1, glass = 1, glass_block = 1},
})

--tinted colorable glass nodes
minetest.register_node("fl_glass:tinted_connected_glass", {
    description = "tinted connected glass",
    drawtype = "glasslike",
    tiles = {"farlands_glass_sheet.png^farlands_glass_detail.png"},
    paramtype = "light",
    paramtype2 = "color",
    sunlight_propagates = true,
    use_texture_alpha = "blend",
    palette = "farlands_palette.png",
    groups = {dig_glass = 1, glass = 1, glass_block = 1},
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
    groups = {dig_glass = 1, glass = 1, glass_block = 1},
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

-- glass panes
minetest.register_node("fl_glass:framed_glass_panes", {
    description = "framed glass pane",
    inventory_image = "farlands_pane_glass.png",
    wield_image = "farlands_pane_glass.png",
    wield_scale = {x = 1, y = 1, z = 0.5},
    drawtype = "nodebox",
    sunlight_propagates = true,
    paramtype = "light",
    use_texture_alpha = "blend",
    tiles = {
        "farlands_demo.png",
        "farlands_demo.png",
        "farlands_pane_glass.png",
    },
    node_box = {
        type = "connected",
        fixed = {{-1/32, -1/2, -1/32, 1/32, 1/2, 1/32}},
        connect_front = {{-1/32, -1/2, -1/2, 1/32, 1/2, -1/32}},
        connect_left = {{-1/2, -1/2, -1/32, -1/32, 1/2, 1/32}},
        connect_back = {{-1/32, -1/2, 1/32, 1/32, 1/2, 1/2}},
        connect_right = {{1/32, -1/2, -1/32, 1/2, 1/2, 1/32}},
    },
    groups = {dig_glass = 2, pane = 1, glass = 1, glass_pane = 1},
    connects_to = cgroups--{"group:pane", "group:glass", "group:wood_related"},
})

minetest.register_node("fl_glass:tinted_framed_glass_panes", {
    description = "tinted framed glass pane",
    inventory_image = "farlands_glass_sheet.png^farlands_pane_glass.png",
    wield_image = "farlands_glass_sheet.png^farlands_pane_glass.png",
    wield_scale = {x = 1, y = 1, z = 0.5},
    drawtype = "nodebox",
    sunlight_propagates = true,
    paramtype = "light",
    paramtype2 = "color",
    palette = "farlands_palette.png",
    use_texture_alpha = "blend",
    tiles = {
        "farlands_demo.png",
        "farlands_demo.png",
        "farlands_glass_sheet.png^farlands_pane_glass.png",
    },
    node_box = {
        type = "connected",
        fixed = {{-1/32, -1/2, -1/32, 1/32, 1/2, 1/32}},
        connect_front = {{-1/32, -1/2, -1/2, 1/32, 1/2, -1/32}},
        connect_left = {{-1/2, -1/2, -1/32, -1/32, 1/2, 1/32}},
        connect_back = {{-1/32, -1/2, 1/32, 1/32, 1/2, 1/2}},
        connect_right = {{1/32, -1/2, -1/32, 1/2, 1/2, 1/32}},
    },
    groups = {dig_glass = 2, pane = 1, glass = 1, glass_pane = 1},
    connects_to = cgroups,--{"group:pane", "group:glass", "group:wood_related",},
    preserve_metadata = function(pos, oldnode, oldmeta, drops)
        drops[1]:get_meta():set_string(
            "description",
            fl_dyes.dyes[oldnode.param2 + 1][2] .. " tinted framed glass pane"
        )
    end,
})

for counter, dye in pairs(fl_dyes.dyes) do
    local out_item = ItemStack(minetest.itemstring_with_palette("fl_glass:tinted_framed_glass_panes", counter - 1))
    out_item:get_meta():set_string("description", fl_dyes.dyes[counter][2] .. " tinted framed glass pane")
    minetest.register_craft({
        output = out_item:to_string(),
        type = "shapeless",
        recipe = {
            "fl_glass:framed_glass_panes",
            "fl_dyes:" .. dye[1] .. "_dye"
        },
    })
end

minetest.register_craft({
    type = "shapeless",
    output = "fl_glass:framed_glass_panes 16",
    recipe = {"fl_glass:framed_glass"}
})

minetest.register_craft({
    type = "cooking",
    output = "fl_glass:framed_glass",
    recipe = "fl_stone:sand",
    cooktime = 3,
})