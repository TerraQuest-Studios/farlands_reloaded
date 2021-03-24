minetest.register_node("fl_glass:glass_connected", {
    description = "connected glass",
    drawtype = "glasslike_framed",
    tiles = {"farlands_glass.png", "farlands_glass_detail.png"},
    paramtype = "light",
    paramtype2 = "glasslikeliquidlevel",
    sunlight_propagates = true,
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_node("fl_glass:glass_framed", {
    description = "framed glass",
    drawtype = "glasslike",
    tiles = {"farlands_glass.png", "farlands_glass_detail.png"},
    paramtype = "light",
    paramtype2 = "glasslikeliquidlevel",
    sunlight_propagates = true,
    groups = {oddly_breakable_by_hand = 3},
})

--make colored glass, probably need to make dyes mod