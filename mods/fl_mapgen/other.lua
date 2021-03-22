--generates at -284 for some reason
minetest.register_on_generated(function(minp, maxp)
    if maxp.y >= -300 and minp.y <= -300 then
        local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
        local data = vm:get_data()
        local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})
        local cid_br = minetest.get_content_id("fl_terrain:bedrock")

        for x = minp.x, maxp.x do
            for z = minp.z, maxp.z do
                local p_pos = area:index(x, 500, z)
                data[p_pos] = cid_br
            end
        end

        vm:set_data(data)
        vm:calc_lighting()
        vm:update_liquids()
        vm:write_to_map()
    end
end)