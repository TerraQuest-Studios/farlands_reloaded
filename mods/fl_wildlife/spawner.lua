local random = math.random
local get_node_light = minetest.get_node_light

local sz = 2 --(sz*2+1, 3, sz*2*1)
local max_obj = 16--tonumber(minetest.settings:get("max_objects_per_block") or 64)
local spawner_mobs = {}
local sm_keys = {}

minetest.register_on_mods_loaded(function()
    for mob, def in pairs(minetest.registered_entities) do
        if def._spawner then
            spawner_mobs[mob] = def._spawner
            table.insert(sm_keys, mob)
        end
    end
end)

local function timer(pos, elapsed)
    --minetest.chat_send_all("timmer activated, elapsed: " .. elapsed)

    local active = false

    local obj_in_rad = minetest.get_objects_inside_radius(pos, 16)
    for _, obj in pairs(obj_in_rad) do
        if obj:is_player() then
            active = true
        end
    end

    local c_air = minetest.get_content_id("air")
    local vm = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map({x=pos.x-sz, y=pos.y-1, z=pos.z-sz}, {x=pos.x+sz, y=pos.y+1, z=pos.z+sz})
    local a = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
    local data = vm:get_data()

    local counter = 0
    local light_table = {
        [1]={}, [2]={}, [3]={},
        [4]={}, [5]={}, [6]={},
        [7]={}, [8]={}, [9]={},
        [10]={}, [11]={}, [12]={},
        [13]={}, [14]={}, [15]={},
    }
    local tod = minetest.get_timeofday()

    for z = pos.z-sz, pos.z+sz do
        for y = pos.y-1, pos.y+1 do
            for x = pos.x-sz, pos.x+sz do
                -- vi, voxel index, is a common variable name here
                local vi = a:index(x, y, z)
                if data[vi] == c_air then
                    counter = counter+1
                    local apos = {x=x, y=y,z=z}
                    table.insert(light_table[get_node_light(apos, tod)], apos)
                end
            end
        end
    end

    --minetest.chat_send_all(counter)

    local meta = minetest.get_meta(pos)
    local spawn_mob = meta:get("mob_spawn") or sm_keys[random(#sm_keys)]
    if not minetest.registered_entities[spawn_mob] then
        --when biome support added, factor it in here
        spawn_mob = sm_keys[random(#sm_keys)]
        meta:set_string("mob_spawn", spawn_mob)
    end

    if active and #obj_in_rad < max_obj then --(max_obj - 10) then
        --minetest.chat_send_all("trigger")
        local j = 0
        while j < random(2,4) do
            local rand = random(spawner_mobs[spawn_mob].min_light or 1, spawner_mobs[spawn_mob].max_light or 15)
            if #light_table[rand] >= 1 then
                --maybe spawned in entities have particles for 2 seconds?
                minetest.add_entity(light_table[rand][random(#light_table[rand])], spawn_mob)
                --minetest.chat_send_all("light: " .. rand)
                j=j+1
            end
        end

        minetest.add_particlespawner({
            amount = 5*10,
            time = 5,
            minpos = pos,
            maxpos = pos,
            minvel = {x = -1, y = -1.5, z = -1},
            maxvel = {x = 1, y = 1.5, z = 1},
            minacc = vector.new(),
            maxacc = vector.new(),
            minexptime = 0.5,
            maxexptime = 1,
            minsize = 1,
            maxsize = 2,
            texture = "farlands_explosion_small.png",
            animation = {type="vertical_frames", aspect_w=32, aspect_h=32, frame_length=1},
            glow = 13,
        })
    --else
        --minetest.chat_send_all("to many mobs in area")
    end

    --minetest.chat_send_all(minetest.pos_to_string(pos))
    --minetest.chat_send_all(minetest.pos_to_string({x=pos.x-10, y=pos.y-1, z=pos.z-10}))
    --minetest.chat_send_all(minetest.pos_to_string({x=pos.x+10, y=pos.y+1, z=pos.z+10}))

    minetest.get_node_timer(pos):start(random(11, 30))
	return false
end

minetest.register_node("fl_wildlife:spawner", {
    description = "wildlife spawner",
    paramtype = "light",
    drawtype = "glasslike",
    tiles = {"farlands_spawner.png"},
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(random(11, 30))
        --need to check pos for biome against def
        local meta = minetest.get_meta(pos)
        meta:set_string("mob_spawn", sm_keys[random(#sm_keys)])
    end,
    on_timer = timer,
    groups = {oddly_breakable_by_hand = 3},
})