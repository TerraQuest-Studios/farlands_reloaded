--todo: make hand get texture from skin
--local modpath = minetest.get_modpath("fl_player")
--local texture_list = minetest.get_dir_list(modpath .. "/textures")

fl_player = {}

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

fl_player.animations = animations
fl_player.ignore = {}

local data_table = {}
local key_table = {}

for _, sn in pairs(minetest.get_dir_list(minetest.get_modpath("fl_player").."/textures")) do
    if sn == "fl_trans.png" then break end
    local nn = string.split(string.split(sn, "_")[2],".")
    table.insert(data_table, {_texture = sn, name = nn[1]})
    key_table[sn] = 1
end

local function get_player_skin(player)
    if player:get_meta():get("skin") and key_table[player:get_meta():get("skin")] then
        return player:get_meta():get("skin")
    end
    return "character_Jonathon.png"
end

minetest.register_on_joinplayer(function(player)
    player:get_meta():set_int("vanish", 0)
    player:set_properties({
        mesh = "fl_character.b3d",
        textures = {get_player_skin(player), "fl_trans.png", "fl_trans.png"},
        visual = "mesh",
        visual_size = {x = 1, y = 1, z = 1},
        collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
        stepheight = 0.6,
        eye_height = 1.47,
    })
    --patch this
    player:set_local_animation(
        {},
        {},
        {},
        {},
        30
    )
end)

minetest.register_globalstep(function(dtime)
    for _, player in pairs(minetest.get_connected_players()) do
        local pcontrols = player:get_player_control()

        player:set_bone_position(
            "Head",
            vector.new(0, 6.35, 0), vector.new(-math.deg(player:get_look_vertical()), 0, 0)
        )

        if fl_player.ignore[player:get_player_name()] then return end

        if math.floor(player:get_properties().eye_height * 100) ~= 147 and not pcontrols.sneak then
            player:set_properties({
                eye_height = 1.47,
            })
            --this allows mods to set this int so that this doesnt reset nametag on them
            if player:get_meta():get_int("vanish") <= 0 then
                player:set_properties({
                    collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
                })
                player:set_nametag_attributes({
                    text = player:get_player_name(),
                    color = {a = 255, r = 255, g = 255, b = 255},
                })
            end
        end

        if pcontrols.sneak then
            if pcontrols.jump then
                player:set_animation(animations["stand"], 15)
                if player:get_meta():get_int("vanish") <= 0 then
                    player:set_properties({
                        collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
                    })
                    player:set_nametag_attributes({
                        text = player:get_player_name(),
                        color = {a = 255, r = 255, g = 255, b = 255},
                    })
                end
            elseif pcontrols.up or pcontrols.down or pcontrols.left or pcontrols.right then
                player:set_animation(animations["duck"], 15)
                player:set_properties({
                    eye_height = 1.3,
                    --collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.5, 0.3},
                })
                if player:get_meta():get_int("vanish") <= 0 then
                    player:set_properties({
                        collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
                    })
                    player:set_nametag_attributes({
                        text = " ",
                        color = {a = 0, r = 255, g = 255, b = 255},
                    })
                end
            else
                player:set_animation(animations["duck_std"], 15)
                player:set_properties({
                    eye_height = 1.3,
                    --collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.5, 0.3},
                })
                if player:get_meta():get_int("vanish") <= 0 then
                    player:set_properties({
                        collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
                    })
                    player:set_nametag_attributes({
                        text = " ",
                        color = {a = 0, r = 255, g = 255, b = 255},
                    })
                end
            end
        elseif pcontrols.up or pcontrols.down or pcontrols.left or pcontrols.right then
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
        if not animations[param] then
            return minetest.chat_send_player(name, "'" .. param .. "' is not a valid animation!")
        end

        minetest.get_player_by_name(name):set_animation(animations[param], 30)
        minetest.chat_send_player(name, "animation " .. param .. " set")
    end,
})
--]]

--[[skins]]--

--needs to fake support skinsdb for i3 support
--[[
data structure dump of skins.get_skinlist_for_player(name) seems to be
{
    license = "", --license
    format = "", --1.0 or 1.8
    _texture = "", --texture filename
    _key = "", --texture name without .png
    author = "" --author name
    _sort_id = number, seems to be 5000?
    name = "", --seems to be texture name with character_ and .png stripped from filename
    __index = {
        set_skin = function,
        set_meta = function,
        get_preview = function,
        get_key = function,
        set_preview = function,
        is_applicable_for_player = function,
        get_texture = function,
        apply_skin_to_player = function,
        get_meta = function,
        get_meta_string = function,
        set_texture = function,
        __index = circlar reference,
    }
}
--]]

skins = {}

function skins.get_skinlist_for_player(name)
    return data_table
end

function skins.set_player_skin(player, skin_entry)
    --minetest.chat_send_all(skin_entry._texture)
    player:get_meta():set_string("skin", skin_entry._texture)
    player:set_properties({
        textures = {get_player_skin(player), "fl_trans.png", "fl_trans.png"},
    })
end

function skins.get_player_skin(player)
    local skin = player:get_meta():get("skin") or "character_Jonathon.png"
    local nn = string.split(string.split(skin, "_")[2],".")
    return {name = nn[1], _texture = skin}
end