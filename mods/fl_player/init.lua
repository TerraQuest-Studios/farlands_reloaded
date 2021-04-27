--todo: make hand get texture from skin
local animations = {
    stand =	{x=0, y=79},
    lay = {x=162, y=166},
    walk = {x=168, y=187},
    mine = {x=189, y=198},
    walk_mine = {x=200, y=219},
    sit = {x=81, y=160},
    swim = {x=246, y=279},
    swim_atk = {x=285, y=318},
    fly = {x=325, y=334},
    fly_atk = {x=340, y=349},
    fall = {x=355, y=364},
    fall_atk = {x=365, y=374},
    duck_std = {x=380, y=380},
    duck = {x=381, y=399},
    climb = {x=410, y=429},
}

minetest.register_on_joinplayer(function(player)
    player:set_properties({
        mesh = "fl_character.b3d",
        textures = {"fl_character.png", "fl_trans.png", "fl_trans.png"},
        visual = "mesh",
        visual_size = {x = 1, y = 1, z = 1},
        collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
        stepheight = 0.6,
        eye_height = 1.47,
    })
    player:set_local_animation(
        animations["stand"],
        animations["walk"],
        animations["mine"],
        animations["walk_mine"],
        30
    )
end)

minetest.register_globalstep(function(dtime)
    for _, player in pairs(minetest.get_connected_players()) do
        local pcontrols = player:get_player_control()

        player:set_bone_position("Head", vector.new(0, 6.35, 0), vector.new(-math.deg(player:get_look_vertical()), 0, 0))

        if pcontrols.up or pcontrols.down or pcontrols.left or pcontrols.right then
            if pcontrols.LMB or pcontrols.RMB then
                player:set_animation(animations["walk_mine"], 30)
            else
                player:set_animation(animations["walk"], 30)
            end
        elseif pcontrols.LMB or pcontrols.RMB then
            player:set_animation(animations["mine"], 30)
        else
            player:set_animation(animations["stand"], 30)
        end
    end
end)

--disable global step before testing using this command
--[[
minetest.register_chatcommand("set_anim", {
    params = "<animation>",
    description = "set player animation",
    func = function(name, param)
        if not animations[param] then return minetest.chat_send_player(name, "'" .. param .. "' is not a valid animation") end

        minetest.get_player_by_name(name):set_animation(animations[param], 30)
        minetest.chat_send_player(name, "animation " .. param .. " set")
    end,
})
--]]