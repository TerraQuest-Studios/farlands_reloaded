minetest.register_node("fl_fire:fire", {
    description = "fire",
    paramtype = "light",
    drawtype = "firelike",
    inventory_image = "farlands_fire_inv.png",
    tiles = {{
        name = "farlands_fire.png",
        animation = {
            type = "vertical_frames",
            aspect_w = 16,
            aspect_h = 16,
            length = 1,
        }
    }},
    light_source = 13,
    walkable = false,
    buildable_to = true,
    sunlight_propagates = true,
    floodable = true,
    damage_per_second = 4,
    drop = "",
    groups = {dig_generic = 4, not_in_creative_inventory = 1, unburnable = 1, attached_node = 1},
})