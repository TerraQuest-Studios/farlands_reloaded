local c_bedrock = core.get_content_id("fl_stone:bedrock")
local c_snow = core.get_content_id("fl_topsoil:snow")

--based off https://github.com/ShadowNinja/minetest_bedrock/blob/master/mapgen.lua license wtfpl
--modify 299 layer tobe more scarce
local bedrock_depth = -300
local bedrock_height = 1

core.register_on_generated(function(vm, minp, maxp, blockseed)
	local mine, maxe = vm:get_emerged_area()
	local area = VoxelArea(mine, maxe)
	local data = vm:get_data()
	local p2_data = vm:get_param2_data()
	local rand = PcgRandom(blockseed)
	local data_changed = false
	local p2_changed = false

	--create bedrock layers
	if minp.y <= bedrock_depth + bedrock_height and maxp.y >= bedrock_depth then
		local lowest = math.max(bedrock_depth, minp.y)
		local highest = math.min(bedrock_depth + bedrock_height, maxp.y)
		for y = lowest, highest do
			for z = minp.z, maxp.z do
				local vi = area:index(minp.x, y, z)
				for _ = minp.x, maxp.x do
					if rand:next(0, y - bedrock_depth) == 0 then
						data[vi] = c_bedrock
						data_changed = true
					end
					vi = vi + 1
				end
			end
		end
	end

	--vary snow layers
	for z = minp.z, maxp.z do
		for y = minp.y, maxp.y do
			local vi = area:index(minp.x, y, z)
			for _ = minp.x, maxp.x do
				if data[vi] == c_snow then
					p2_data[vi] = rand:next(2, 4)*8
					p2_changed = true
				end
				vi = vi + 1
			end
		end
	end

	if data_changed then vm:set_data(data) end
	if p2_changed then vm:set_param2_data(p2_data) end
end)

local chest_id = "fl_storage:wood_chest"

local function random_sample(rand, list, count)
	local ret = {}
	for _ = 1, count do
		local idx = rand:next(1, #list)
		table.insert(ret, list[idx])
		table.remove(list, idx)
	end
	return ret
end

local function find_walls(vm, cpos)
	local is_wall = function(node)
		return node.name ~= "air" and node.name ~= "ignore"
	end

	local dirs = {{x=1, z=0}, {x=-1, z=0}, {x=0, z=1}, {x=0, z=-1}}

	local ret = {}
	local mindist = {x=0, z=0}
	local min = function(a, b)
		return a ~= 0 and math.min(a, b) or b
	end
	for _, dir in ipairs(dirs) do
		for i = 1, 9 do -- 9 = max room size / 2
			local pos = vector.add(cpos, {x=dir.x*i, y=0, z=dir.z*i})

			-- continue in that direction until we find a wall-like node
			local node = vm:get_node_at(pos)
			if is_wall(node) then
				local front_below = vector.subtract(pos, {x=dir.x, y=1, z=dir.z})
				local above = vector.add(pos, {x=0, y=1, z=0})

				-- check that it:
				--- is at least 2 nodes high (not a staircase)
				--- has a floor
				if is_wall(vm:get_node_at(front_below)) and is_wall(vm:get_node_at(above)) then
					table.insert(ret, {pos = pos, facing = {x=-dir.x, y=0, z=-dir.z}})
					if dir.z == 0 then
						mindist.x = min(mindist.x, i-1)
					else
						mindist.z = min(mindist.z, i-1)
					end
				end
				-- abort even if it wasn't a wall cause something is in the way
				break
			end
		end
	end

	return {
		walls = ret,
		size = {x=mindist.x*2, z=mindist.z*2},
	}
end

--chest counts are set by the main thread from dungeon_loot, read once
local chests_min, chests_max

core.register_on_generated(function(vm, _, _, blockseed)
	local gennotify = core.get_mapgen_object("gennotify")
	local poslist = gennotify["dungeon"] or {}
	for _, entry in ipairs(gennotify["temple"] or {}) do
		table.insert(poslist, entry)
	end
	if #poslist == 0 then return end

	if not chests_min then
		local range = core.ipc_get("fl_mapgen:chest_range") or {0, 2}
		chests_min, chests_max = range[1], range[2]
	end

	local rand = PcgRandom(blockseed)

	local candidates = {}
	-- process at most 8 rooms to keep runtime of this predictable
	local num_process = math.min(#poslist, 8)
	for i = 1, num_process do
		local room = find_walls(vm, poslist[i])
		-- skip small rooms and everything that doesn't at least have 3 walls
		if math.min(room.size.x, room.size.z) >= 4 and #room.walls >= 3 then
			table.insert(candidates, room)
		end
	end

	local num_chests = rand:next(chests_min, chests_max)
	num_chests = math.min(#candidates, num_chests)
	local rooms = random_sample(rand, candidates, num_chests)

	for _, room in ipairs(rooms) do
		-- choose place somewhere in front of any of the walls
		local wall = room.walls[rand:next(1, #room.walls)]
		local v, vi -- vector / axis that runs alongside the wall
		if wall.facing.x ~= 0 then
			v, vi = {x=0, y=0, z=1}, "z"
		else
			v, vi = {x=1, y=0, z=0}, "x"
		end
		local chestpos = vector.add(wall.pos, wall.facing)
		local off = rand:next(-room.size[vi]/2 + 1, room.size[vi]/2 - 1)
		chestpos = vector.add(chestpos, vector.multiply(v, off))

		if vm:get_node_at(chestpos).name == "air" then
			-- make it face inwards to the room
			local facedir = core.dir_to_facedir(vector.multiply(wall.facing, -1))
			vm:set_node_at(chestpos, {name = chest_id, param2 = facedir})
			--need to add in a way of placing spawners here
		end
	end
end)
