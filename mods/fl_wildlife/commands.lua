minetest.register_chatcommand("clearents", {
    description = "remove sepcified ents",
    params = "<ent_name><radius>",
    privs = {server = true},
    func = function(name, param)
        local counter = 0
        local player = minetest.get_player_by_name(name)
        local split = param:split(" ")
        local radius = 32
        if split[2] then radius = tonumber(split[2]) end
        if not minetest.registered_entities[split[1]] then return false, "not valid ent" end
        local objects = minetest.get_objects_inside_radius(player:get_pos(), radius)

        for _, obj in pairs(objects) do
            local ent = obj:get_luaentity()
            if ent and ent.name == split[1] then obj:remove() counter = counter+1 end
        end

        return true, "[fl_wildlife]: " .. counter .. " ents removed"
    end
})
