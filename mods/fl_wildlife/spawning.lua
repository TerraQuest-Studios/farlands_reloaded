--localize libraries
local v_dist, v_multiply, v_add = vector.distance, vector.multiply, vector.add
local m_random, m_pi = math.random, math.pi

--varibles
local abr = minetest.get_mapgen_setting('active_block_range') or 4
local mopb = minetest.settings:get("max_objects_per_block") or 64

--[[
    {
        biomes - table, or leave blank for all
        rarity - number between 0 and 1 for spawning (required)
        y_min - min spawn height
        y_max - max spawn height
        light_min - min light level
        light_max - max light level
        light_type - (total) changes light calc from natural to natural+light sources
            useful for hostile mobs where you want them to be switched on or off by torches
        cluster - if present, amount of times another mob is attempted to be spawned
    }
]]

local mob_biomes = {}
local mob_spawndata = {}

--fill data cache. technically this currently doesnt account for dynamically registered mobs
minetest.register_on_mods_loaded(function()
    for biome, _ in pairs(minetest.registered_biomes) do
        mob_biomes[biome] = {}
    end
    for ename, edef in pairs(minetest.registered_entities) do
        if edef._spawning and edef._spawning.biomes then
            mob_spawndata[ename] = table.copy(edef._spawning)
            for _, biome in pairs(edef._spawning.biomes) do
                if mob_biomes[biome] then table.insert(mob_biomes[biome], ename) end
            end
        elseif edef._spawning then
            mob_spawndata[ename] = table.copy(edef._spawning)
            for biome, _ in pairs(mob_biomes) do
                table.insert(mob_biomes[biome], ename)
            end
        end
    end
end)

function find_nodes(p_min, p_max)
    --local time = minetest.get_us_time()

    --[[
        --voxel manip very much slower than minetest.find_nodes_in_area_under_air
    local vm = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map(p_min, p_max)
    local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
    local data = vm:get_data()

    local c_air = minetest.get_content_id("air")
    local pos_list = {}

    for vi in area:iterp(emin, emax) do
        local def = minetest.registered_items[minetest.get_name_from_content_id(data[vi])]
        local pos = area:position(vi)

        if def.walkable and def.groups and not def.groups.spawn_blacklist and
        data[area:index(pos.x, pos.y + 1, pos.z)] == c_air then
            table.insert(pos_list, vector.new(pos.x, pos.y + 1, pos.z))
        end
    end
    ]]
    local gcheck = minetest.get_item_group
    local list = minetest.find_nodes_in_area_under_air(p_min, p_max, "group:all_nodes")
    local pos_list = {}

    for _, pos in pairs(list) do
        --node under is checked for situations like snow on tree leaves, etc
        local def = minetest.registered_items[minetest.get_node(pos).name]
        local def2 = minetest.registered_items[minetest.get_node(vector.new(pos.x,pos.y-1,pos.z)).name]
        if def.walkable and gcheck(def.name, "spawn_blacklist") <= 0 and gcheck(def2.name, "spawn_blacklist") <= 0 then
            table.insert(pos_list, vector.new(pos.x, pos.y+1, pos.z))
        end
    end

    --minetest.chat_send_all("find time: " .. minetest.get_us_time()-time)
    --minetest.chat_send_all(#pos_list)

    return pos_list
end

local function spawn_mob(stable, cmob, ccount)
    --local time = minetest.get_us_time()

    local index = m_random(#stable)
    local pos = stable[index]
    local light = minetest.get_natural_light(pos)
    local biome = minetest.get_biome_name(minetest.get_biome_data(pos).biome)

    --catches "default" biome aka no biome present
    if not mob_biomes[biome] then
        return
    end

    local mob = cmob or mob_biomes[biome][m_random(#mob_biomes[biome])]

    if mob_spawndata.light_type and mob_spawndata.light_type == "total" then
        light = minetest.get_node_light(pos)
    end

    --minetest.chat_send_all(mob)

    if (mob_spawndata[mob].y_min or -33000) > pos.y or (mob_spawndata[mob].y_max or 33000) < pos.y then
        return
    elseif (mob_spawndata[mob].light_min or 0) > light or (mob_spawndata[mob].light_max or 15) < light then
        return
    elseif m_random() > mob_spawndata[mob].rarity then
        return
    end

    --minetest.chat_send_all("sucess: " .. (ccount or 0))
    local ent = minetest.add_entity(pos, mob)
    if minetest.registered_entities[mob]._on_spawn then
        minetest.registered_entities[mob]._on_spawn(ent)
    end

    --minetest.chat_send_all("spawn time: " .. minetest.get_us_time()-time)

    --use recursion for cluster spawning
    table.remove(stable, index)
    if not ccount and mob_spawndata[mob].cluster then
        ccount = mob_spawndata[mob].cluster - 1
        spawn_mob(stable, mob, ccount)
    elseif ccount and ccount-1 > 0 then
        ccount = ccount - 1
        spawn_mob(stable, cmob, ccount)
    end
end

local function spawn_step()
    --slow down mobs spawning overall, save calc time
    if m_random() > 0.5 then
        --minetest.chat_send_all("nuked")
        minetest.after(11, spawn_step)
        return
    end
    --local time = minetest.get_us_time()

    --minetest.chat_send_all("fired")

    for _, player in pairs(minetest.get_connected_players()) do
        local p_pos = player:get_pos()
        local m_count, e_count = 0, 0
        local y_mod = p_pos.y < -4 and 0.5 or 1
        local yaw = (m_random(0, 360) - 180) / 180 * m_pi
        local l_dist = abr*16*y_mod*(m_random(0,0.5)+0.5)
        local dist = v_multiply(minetest.yaw_to_dir(yaw),l_dist)
        local s_pos = v_add(p_pos, dist)
        local s_table = find_nodes(
            vector.new(s_pos.x-10, s_pos.y-20, s_pos.z-10),
            vector.new(s_pos.x+10, s_pos.y+20, s_pos.z+10)
        )

        for _, ent in pairs(minetest.luaentities) do
            --check for pos to prevent crash
            if ent.object:get_pos() and v_dist(ent.object:get_pos(), p_pos) <= (abr*16*2)+5 then
                e_count = e_count + 1
                if ent.brainfunc then
                    m_count = m_count + 1
                end
            end
        end

        --make sure not to many mobs/ents in area
        if #s_table > 0 and mopb*.8 > e_count and (mopb*.5) > m_count then
            spawn_mob(s_table)
        end
    end

    --minetest.chat_send_all("step time: " .. minetest.get_us_time()-time)

    minetest.after(11, spawn_step)
end

minetest.after(11, spawn_step)