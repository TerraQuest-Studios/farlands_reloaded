local dist = tonumber(minetest.settings:get("player_transfer_distance")) or 32

-----------------
--chat distance--
-----------------

minetest.register_privilege("global_chat", {
    description = "allows you to send messages to all users",
    give_to_singleplayer = false,
})

--modified from greenxenith, MIT
minetest.register_on_chat_message(function(name, msg)
    --checking that the message is not sent from terminal
    if minetest.get_player_by_name(name) then
        local pos = minetest.get_player_by_name(name):get_pos()
        for _, player in ipairs(minetest.get_connected_players()) do
            if vector.distance(pos, player:get_pos()) <= dist then
                if msg:find(player:get_player_name(), 1, true) then
                    msg = minetest.colorize("#00ff00", msg)
                end
                minetest.chat_send_player(player:get_player_name(), ("<%s> %s"):format(name, msg))
            end
        end
        return true
    --messages sent from the terminal are exicuted as the name value, so they are considered admin
    else return false end
end)

minetest.override_chatcommand("msg", {
    func = function(name, param)
        local destination, msg = param:match("^(%S+)%s(.+)$")
        if not destination then return false, "Invalid Usage, see /help msg." end
        if not minetest.get_player_by_name(destination) then return false, destination .. " is not online" end
        if minetest.get_player_by_name(name)
        and vector.distance(
            minetest.get_player_by_name(name):get_pos(),
            minetest.get_player_by_name(destination):get_pos()
        ) <= dist then
            minetest.chat_send_player(destination, minetest.colorize("#00ff00", "DM from " .. name .. ": " .. msg))
        else
            return false, destination .. " is not in range"
        end
    end,
})

minetest.register_chatcommand("global", {
    params = "<msg>",
    description = "send message to all users",
    privs = {global_chat=true},
    func = function(name, param)
        if param ~= "" then
            minetest.chat_send_all(("(Global) <%s> %s"):format(name, param))
        else
            return false, "Cannot send empty message."
        end
    end,
})