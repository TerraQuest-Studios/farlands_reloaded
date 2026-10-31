--hack to change player hotbar texture
core.register_on_joinplayer(function(player)
    --minetest.after(0.1, function()
        --player:hud_set_hotbar_image("farlands_hotbar.png") --hack moved to /textures
        player:hud_set_hotbar_selected_image("farlands_hotbar_selector7.png")
    --end)
end)

--temperary hacks around i3 bag crafts
core.register_alias("farming:string", "fl_stone:stone")
core.clear_craft({output = "i3:bag_small"})

core.register_craft({
    output = "i3:bag_small",
    recipe = {
        {"", "farming:string", ""},
        {"group:wool", "group:wool", "group:wool",},
        {"group:wool", "group:wool", "group:wool",},
	}
})

