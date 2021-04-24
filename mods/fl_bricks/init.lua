minetest.register_node("fl_bricks:brick", {
    description = "brick",
    tiles = {"farlands_brick.png^[multiply:#f3f3f3"},
    --tiles = {"farlands_brick.png"},
    overlay_tiles = {
        { name = "farlands_mortar.png", color = "white" }
    },
    paramtype = "light",
    paramtype2 = "color",
    --sunlight_propagates = true,
    palette = "farlands_palette.png",
    groups = {oddly_breakable_by_hand = 3},
    preserve_metadata = function(pos, oldnode, oldmeta, drops)
        drops[1]:get_meta():set_string("description", fl_dyes.dyes[oldnode.param2 + 1][2] .. " brick")
        if fl_dyes.dyes[oldnode.param2 + 1][2] == "White" then
            drops[1]:get_meta():set_string("description", "brick")
        end
    end,
})

minetest.register_craftitem("fl_bricks:clay", {
    description = "clay",
    inventory_image = "farlands_clay.png"
})

minetest.register_node("fl_bricks:clay_block", {
    description = "clay block",
    tiles = {"farlands_clay_block.png"},
    drop = "fl_bricks:clay 4",
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_craftitem("fl_bricks:raw_brick", {
    description = "raw brick",
    inventory_image = "farlands_raw_brick.png"
})

minetest.register_node("fl_bricks:terracotta", {
    description = "terracotta",
    tiles = {"farlands_terracotta_base.png^farlands_terracotta_overlay.png"},
    paramtype = "light",
    paramtype2 = "color",
    --sunlight_propagates = true,
    palette = "farlands_palette.png",
    groups = {oddly_breakable_by_hand = 3},
    preserve_metadata = function(pos, oldnode, oldmeta, drops)
        drops[1]:get_meta():set_string("description", fl_dyes.dyes[oldnode.param2 + 1][2] .. " terracotta")
    end,
})

--crafts
for counter, dye in pairs(fl_dyes.dyes) do
    local brick_item = ItemStack(minetest.itemstring_with_palette("fl_bricks:brick", counter - 1))
    brick_item:get_meta():set_string("description", fl_dyes.dyes[counter][2] .. " brick")
    if fl_dyes.dyes[counter][2] == "White" then
        brick_item:get_meta():set_string("description", "brick")
    end
    minetest.register_craft({
        output = brick_item:to_string(),
        type = "shapeless",
        recipe = {
            "fl_bricks:brick",
            "fl_dyes:" .. dye[1] .. "_dye"
        },
    })
    minetest.register_craft({
        output = brick_item:to_string(),
        recipe = {
            {"fl_bricks:raw_brick", "fl_bricks:raw_brick", "fl_dyes:" .. dye[1] .. "_dye"},
            {"fl_bricks:raw_brick", "fl_bricks:raw_brick", ""},
            {"", "", ""}
        }
    })
end

local out_item = ItemStack(minetest.itemstring_with_palette("fl_bricks:brick", 0))
out_item:get_meta():set_string("description", "brick")
minetest.register_craft({
    output = out_item:to_string(),
    recipe = {
        {"fl_bricks:raw_brick", "fl_bricks:raw_brick", ""},
        {"fl_bricks:raw_brick", "fl_bricks:raw_brick", ""},
        {"", "", ""}
    }
})

minetest.register_craft({
    output = "fl_bricks:clay_block",
    recipe = {
        {"fl_bricks:clay", "fl_bricks:clay", ""},
        {"fl_bricks:clay", "fl_bricks:clay", ""},
        {"", "", ""}
    }
})