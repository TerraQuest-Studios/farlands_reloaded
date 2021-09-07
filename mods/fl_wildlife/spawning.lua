--very broken spawn
local abr = minetest.get_mapgen_setting('active_block_range')

--fill data
--_spawn_def = {y_level = {y_min, y_max}, biomes = {}}
--currently global for testing
mob_table = {}
mob_table.y_levels = {}
minetest.register_on_mods_loaded(function()
    for bname, bdef in pairs(minetest.registered_biomes) do
        mob_table[bname] = {}
    end

    for _, ent in pairs(minetest.registered_entities) do
        if ent._spawn_def then
            if ent._spawn_def.biomes then
                for _, biome in pairs(ent._spawn_def.biomes) do
                    mob_table[biome] = ent.name
                end
            else
                for biome, _ in pairs(mob_table) do
                    table.insert(mob_table[biome], ent.name)
                end
            end
            if ent._spawn_def.y_level then
                mob_table.y_levels[ent.name] = ent._spawn_def.y_level
            end
        elseif ent.brainfunc and ent._spawn_ignore ~= true then
            for biome, _ in pairs(mob_table) do
                table.insert(mob_table[biome], ent.name)
            end
        end
    end
    --if dynamic ents where to be supported
    --[[
    local reg_ent = minetest.register_entity
    function minetest.register_entity(name, ent_def)
        --insert into mob_table here logic
        return reg_ent(name, ent_def)
    end
    --]]
end)

local function is_mob(obj)
    if type(obj) == "userdata" then
        obj = obj:get_luaentity()
        if type(obj) == "table" and obj.brainfunc then return true end
    end
    return false
end

local function spawning()
    for _, player in pairs(minetest.get_connected_players()) do
        local vel = player:get_velocity()
        local spd = vector.length(vel)
        local yaw
        if spd > 1 then yaw = player:get_look_horizontal() + math.random()*0.35 - 0.75 else yaw = math.random()*math.pi*2 - math.pi end
        local dir = vector.multiply(minetest.yaw_to_dir(yaw),abr*16)
        local pos = vector.add(player:get_pos(),dir)
        pos.y=pos.y-5
        local height, liquidflag = mobkit.get_terrain_height(pos, 32)

        --abort spawning if over max limit for area
        --local objs = minetest.get_objects_inside_radius(player:get_pos(),abr*16+5)
        if liquidflag then minetest.chat_send_all("liquid") end

        if height and height >= 0 and not liquidflag
        and mobkit.nodeatpos({x=pos.x,y=height-0.01,z=pos.z}).is_ground_content
        and mobkit.nodeatpos({x=pos.x,y=height-0.5,z=pos.z}).is_ground_content then
            --added check below for leaves with snow
            local objs = minetest.get_objects_inside_radius(player:get_pos(),abr*16+5)
            local mob_count = 0
            for _, obj in pairs(objs) do
                if is_mob(obj) then mob_count = mob_count+1 end
            end
            if #objs - mob_count > 32 then mob_count = #objs end
            if mob_count < 32 then
                pos.y = height + 0.5
                local biome = minetest.get_biome_name(minetest.get_biome_data(pos).biome)
                minetest.chat_send_all(mob_table[biome][math.random(#mob_table[biome])])
                local ent = "fl_wildlife:sheep"
                local ent_ref = minetest.add_entity(pos, ent)
                if minetest.registered_entities[ent]._on_spawn then
                    minetest.registered_entities[ent]._on_spawn(ent_ref)
                end
                minetest.chat_send_all("spawned")
            end
        end
    end

    minetest.after(5, spawning)
end

minetest.after(5, spawning)