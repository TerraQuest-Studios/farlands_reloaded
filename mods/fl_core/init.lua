-- add sounds and core stuff here
minetest.log("info", "[fl_core]: core loaded")

minetest.register_on_joinplayer(function(player)
    local pinfo = minetest.get_player_information(player:get_player_name())
    if pinfo.formspec_version < 4  then
        minetest.kick_player(player:get_player_name(), "please use a formspec v4 client (5.4) client")
    end
end)

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    if itemstack:get_meta():get_string("description") ~= "" then
        local meta = minetest.get_meta(pos)
        meta:set_string("description", itemstack:get_meta():get_string("description"))
    end
end)

minetest.register_on_mods_loaded(function()
    --other on loaded registered nodes add this themselves, see fl_stairs
    for node, def in pairs(minetest.registered_nodes) do
        local groups = table.copy(def.groups)
        groups["all_nodes"] = 1
        minetest.override_item(node, {
            groups = groups
        })
    end
end)