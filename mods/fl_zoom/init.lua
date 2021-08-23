local zoom = {}

minetest.register_on_joinplayer(function(player, last_login)
    player:set_properties({zoom_fov = 0})
    --by disabling the zoom key, we allow it to be used fo other functions
end)

minetest.register_craftitem("fl_zoom:binoculars", {
    inventory_image = "[combine:16x16",
    description = "binoculars",
    stack_max = 1,
    on_use = function(itemstack, user, pointed_thing)
        if user:get_fov() == 0 then
            user:set_fov(10)
            local hud = user:hud_add({
                hud_elem_type = "image",
                position = {x=0.5,y=0.5},
                scale = {x=-100,y=-100},
                text = "[combine:32x16:0,0=farlands_glass_detail.png:16,0=farlands_glass_detail.png"
            })
            user:hud_set_flags({
                wielditem = false,
                hotbar = false,
                healthbar = false,
                breathbar = false,
                minimap = false,
                minimap_radar = false,
            })
            zoom[user:get_player_name()] = hud
        elseif user:get_fov() == 10 then
            user:set_fov(0)
            user:hud_set_flags({
                wielditem = true,
                hotbar = true,
                healthbar = true,
                breathbar = true,
                minimap = true,
                minimap_radar = true,
            })
            user:hud_remove(zoom[user:get_player_name()])
            zoom[user:get_player_name()] = nil
        end
        return nil
    end,
})

minetest.register_on_dieplayer(function(player)
    if zoom[player:get_player_name()] then
        player:set_fov(0)
        player:hud_set_flags({
            wielditem = true,
            hotbar = true,
            healthbar = true,
            breathbar = true,
            minimap = true,
            minimap_radar = true,
        })
        player:hud_remove(zoom[player:get_player_name()])
        zoom[player:get_player_name()] = nil
    end
end)

minetest.register_on_leaveplayer(function(player)
    zoom[player:get_player_name()] = nil
end)
--fixme:player can place nodes, probably revoke interact to fix this