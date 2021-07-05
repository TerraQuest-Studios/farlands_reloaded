--[[
    --dump of breath bar
{
    scale = {y=0, x=0},
    position = {y=1, x=0.5},
    z_index = 0,
    alignment = {y=0, x=0},
    direction = 0,
    text2 = "bubble_gone.png",
    text = "bubble.png",
    number = 18,
    offset = {y=-88, x=25},
    world_pos={y=0, x=0, z=0},
    dir = 0,
    type = "statbar",
    item = 20,
    name = "",
    size = {y=24,x=24},
}
--]]

--do nothing here if damage not enabled
if not minetest.settings:get_bool("enable_damage") then return end

local hunger_data = {}


local breath_bar_def = {
    hud_elem_type = "statbar",
    position = {x=0.5, y=1},
    text = "bubble.png",
    text2 = "bubble_gone.png",
    number = 18,
    item = 20,
    direction = 0,
    size = {x = 24, y = 24},
    offset = {y=-88+-16*2, x=25},
}

core.hud_replace_builtin("breath", breath_bar_def)

--init data
minetest.register_on_joinplayer(function(player, last_login)
    local hv = player:get_meta():get("hunger_value") or 20
    hunger_data[player:get_player_name()] = {hunger_value = hv, node_interact = 0}

    local id = player:hud_add({
        hud_elem_type = "statbar",
        position = {x=0.5, y=1},
        text = "hunger.png",
        text2 = "hunger_gone.png",
        number = hv,
        item = 20,
        direction = 0,
        size = {x = 24, y = 24},
        offset = {y=-88, x=25},
    })
    hunger_data[player:get_player_name()]["id"] = id
end)

--write data
minetest.register_on_leaveplayer(function(player, timed_out)
    player:get_meta():set_string("hunger_value", hunger_data[player:get_player_name()]["hunger_value"])
end)
minetest.register_on_shutdown(function()
    for _, player in pairs(minetest.get_connected_players()) do
        player:get_meta():set_string("hunger_value", hunger_data[player:get_player_name()]["hunger_value"])
    end
end)
local function write_data()
    for _, player in pairs(minetest.get_connected_players()) do
        player:get_meta():set_string("hunger_value", hunger_data[player:get_player_name()]["hunger_value"])
    end
    minetest.after(600, write_data)
end
minetest.after(600, write_data)

local old_eat = minetest.do_item_eat
function minetest.do_item_eat(hp_change, replace_with_item, itemstack, user, pointed_thing)

    if hunger_data[user:get_player_name()]["hunger_value"] < 20 then
        local hpchange = 0
        local change = hunger_data[user:get_player_name()]["hunger_value"] + hp_change

        if change > 20 then
            hpchange = change - 20
            hunger_data[user:get_player_name()]["hunger_value"] = 20
        else
            hunger_data[user:get_player_name()]["hunger_value"] = change
        end

        user:hud_change(hunger_data[user:get_player_name()]["id"], "number", hunger_data[user:get_player_name()]["hunger_value"])

        return old_eat(hpchange, replace_with_item, itemstack, user, pointed_thing)
    else
        return old_eat(hp_change, replace_with_item, itemstack, user, pointed_thing)
    end
end

local function node_hunger(_, _, player, test, _, _, _, _, _, val)
    if not player or not player:is_player() or player.is_fake_player == true then return end
    local interaction = hunger_data[player:get_player_name()]["node_interact"]

    if test then
        --digging
        interaction = interaction + 3
    elseif val then
        --custom input
        interaction = interaction + val
    else
        --placing/other stuff only a point
        interaction = interaction + 1
    end

    if interaction > 150 then
        if tonumber(hunger_data[player:get_player_name()]["hunger_value"]) >= 1 then
            hunger_data[player:get_player_name()]["hunger_value"] = hunger_data[player:get_player_name()]["hunger_value"] - 1
        else
            player:set_hp(player:get_hp()-1)
        end
        player:hud_change(hunger_data[player:get_player_name()]["id"], "number", hunger_data[player:get_player_name()]["hunger_value"])
        interaction = 0
    end
    hunger_data[player:get_player_name()]["node_interact"] = interaction
end

minetest.register_on_placenode(node_hunger)
minetest.register_on_dignode(node_hunger)

local function after()
    for _, player in pairs(minetest.get_connected_players()) do
        local controls = player:get_player_control()
        if controls.up or controls.down or controls.left or controls.right then
            node_hunger(nil, nil, player, "randomness")
        else
            node_hunger(nil, nil, player)
        end
    end
    minetest.after(4, after)
end

minetest.after(4, after)





--testing debug junk
fl_hunger = {}

function fl_hunger.set_hunger(user, value)
    hunger_data[user:get_player_name()]["hunger_value"] = value
    user:hud_change(hunger_data[user:get_player_name()]["id"], "number", hunger_data[user:get_player_name()]["hunger_value"])
end