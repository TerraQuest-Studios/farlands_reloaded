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

--override this core command to allow killing mobs
minetest.override_chatcommand("kill", {
    params = "<playername|mobname>",
    description = "Kill entity(mob), player, or yourself",
    func = function(name, param)
        local player = minetest.get_player_by_name(param)

        if player then
            if minetest.settings:get_bool("enable_damage") == false then
                return false, "You can not kill players as damage is disabled"
            end

            if player:get_hp() <= 0 then
                return false, "Target player " .. param .. " is already dead"
            end

            player:set_hp(0)
            return true, "Player " .. param .. " killed"
        end

        local entity = minetest.registered_entities[param]

        if entity then
            local removed_ent_count = 0

            for _, ent in pairs(minetest.luaentities) do
                if ent.name == param then
                    --maybe consider adding a check to see if the entity is a mob
                    --and setting its hp to 0 so it can run its death callback
                    ent.object:remove()
                    removed_ent_count = removed_ent_count + 1
                end
            end

            return true, "Removed " .. removed_ent_count .. " entities of type " .. param
        end

        return false, "Invalid entity name or player name"
    end
})
