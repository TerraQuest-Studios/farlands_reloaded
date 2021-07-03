minetest.register_node("fl_wool:wool", {
    description = "wool",
    tiles = {"farlands_wool.png"},
    paramtype = "light",
    paramtype2 = "color",
    --sunlight_propagates = true,
    palette = "farlands_palette.png",
    groups = {oddly_breakable_by_hand = 3},
    preserve_metadata = function(pos, oldnode, oldmeta, drops)
        drops[1]:get_meta():set_string("description", fl_dyes.dyes[oldnode.param2 + 1][2] .. " wool")
    end,
})

--note the wield item looks like junk
minetest.register_node("fl_wool:wool_carpet", {
    description = "wool carpet",
    tiles = {"farlands_wool.png"},
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "color",
    --sunlight_propagates = true,
    palette = "farlands_palette.png",
    node_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, -7/16, 0.5}
    },
    groups = {oddly_breakable_by_hand = 3},
    preserve_metadata = function(pos, oldnode, oldmeta, drops)
        drops[1]:get_meta():set_string("description", fl_dyes.dyes[oldnode.param2 + 1][2] .. " wool carpet")
    end,
})

for counter, dye in pairs(fl_dyes.dyes) do
    local out_item = ItemStack(minetest.itemstring_with_palette("fl_wool:wool", counter - 1))
    out_item:get_meta():set_string("description", fl_dyes.dyes[counter][2] .. " wool")
    minetest.register_craft({
        output = out_item:to_string(),
        type = "shapeless",
        recipe = {
            "fl_wool:wool",
            "fl_dyes:" .. dye[1] .. "_dye"
        },
    })
end