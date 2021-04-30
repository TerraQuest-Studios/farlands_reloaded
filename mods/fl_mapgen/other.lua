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