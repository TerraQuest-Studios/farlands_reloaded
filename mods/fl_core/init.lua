-- add sounds and core stuff here
minetest.log("info", "[fl_core]: core loaded")

minetest.register_on_joinplayer(function(player)
    local pinfo = minetest.get_player_information(player:get_player_name())
    if pinfo.formspec_version < 4  then
        minetest.kick_player(player:get_player_name(), "please use a formspec v4 client (5.4) client")
    end
end
)