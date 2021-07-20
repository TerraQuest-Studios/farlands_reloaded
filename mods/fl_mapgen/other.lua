--based off https://github.com/ShadowNinja/minetest_bedrock/blob/master/mapgen.lua license wtfpl
--modify 299 layer tobe more scarce
local bedrock_depth = -300
local bedrock_height = 1

minetest.register_on_generated(function(minp, maxp)
	if minp.y > bedrock_depth + bedrock_height or maxp.y < bedrock_depth then
		return
	end

	local vm, mine, maxe = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new({MinEdge=mine, MaxEdge=maxe})
	local data = vm:get_data()

	local random = math.random

	local c_bedrock = minetest.get_content_id("fl_stone:bedrock")

	local highest = math.min(bedrock_depth + bedrock_height, maxe.y)
	local lowest = math.max(bedrock_depth, mine.y)

	for y = lowest, highest do
	for x = mine.x, maxe.x do
	for z = mine.z, maxe.z do
		if random(0, y - bedrock_depth) == 0 then
			data[area:index(x, y, z)] = c_bedrock
		end
	end
	end
	end
	vm:set_data(data)
	vm:write_to_map()
end)

minetest.register_on_generated(function(minp, maxp)
    local vm, mine, maxe = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new({MinEdge=mine, MaxEdge=maxe})
	local data = vm:get_data()
    local p2_data = vm:get_param2_data()
    local random = math.random
    local c_snow = minetest.get_content_id("fl_topsoil:snow")

    for z = mine.z, maxe.z do
        for y = mine.y, maxe.y do
            for x = mine.z, maxe.z do
                -- vi, voxel index, is a common variable name here
                local vi = area:index(x, y, z)
                if data[vi] == c_snow then
                    p2_data[vi] = random(2,4)*8
                end
            end
        end
    end

    vm:set_param2_data(p2_data)
    vm:write_to_map()
end)