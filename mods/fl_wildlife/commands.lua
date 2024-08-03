--override this core command to allow killing mobs
minetest.override_chatcommand("kill", {
    params = "<playername|mobname> [<radius>]",
    description = "Kill entity(mob), player, or yourself",
    func = function(name, param)
        local split_param = param:split(" ")
        local target = split_param[1]
        local radius = split_param[2] and tonumber(split_param[2]) or nil
        local player = minetest.get_player_by_name(target)

        if player then
            if minetest.settings:get_bool("enable_damage") == false then
                return false, "You can not kill players as damage is disabled"
            end

            if player:get_hp() <= 0 then
                return false, "Target player " .. target .. " is already dead"
            end

            player:set_hp(0)
            return true, "Player " .. target .. " killed"
        end

        local entity = minetest.registered_entities[target]

        if entity then
            local removed_ent_count = 0
            local command_player = minetest.get_player_by_name(name)

            if radius and not command_player then
                return false, "Only in game players can use the radius parameter"
            end

            --command player pos
            --set this after the check for command player
            local cp_pos = command_player:get_pos()

            for _, ent in pairs(minetest.luaentities) do
                if ent.name == target then
                    --maybe consider adding a check to see if the entity is a mob
                    --and setting its hp to 0 so it can run its death callback

                    if (radius and vector.distance(ent.object:get_pos(), cp_pos) <= radius) or not radius then
                        ent.object:remove()
                        removed_ent_count = removed_ent_count + 1
                    end

                end
            end

            return true, "Removed " .. removed_ent_count .. " entities of type " .. target
        end

        return false, "Invalid entity name or player name"
    end
})

minetest.register_chatcommand("clearents", {
    description = "remove sepcified ents",
    params = "<ent_name><radius>",
    privs = {server = true},
    func = function(name, param)
        minetest.chat_send_player(
            name,
            minetest.colorize("red", "WARNING: this command is depreciated, use /kill in the future")
        )
        return minetest.registered_chatcommands.kill.func(name, param)
    end
})
