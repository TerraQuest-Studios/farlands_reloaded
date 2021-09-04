for i = 1, 5 do
    minetest.register_decoration({
        name = "fl_plantlife:savannah_grass_" .. i,
        deco_type = "simple",
        place_on = {"fl_topsoil:savannah_dirt_with_grass"},
        sidelen = 16,
        --higher seems to cause mapgen light bugs
        fill_ratio = 0.001,
        biomes = {"savannah"},
        y_max = 300,
        y_min = 4,
        param2 = 1,
        param2_max = 255,
        decoration = "fl_plantlife:savannah_grass_" .. i
    })
end

for i = 1, 5 do
    minetest.register_decoration({
        name = "fl_plantlife:grass_" .. i,
        deco_type = "simple",
        place_on = {"fl_topsoil:dirt_with_grass"},
        sidelen = 16,
        fill_ratio = 0.08,
        biomes = {"grassland", "deciduousforest"},
        y_max = 300,
        y_min = 4,
        param2 = 1,
        param2_max = 255,
        decoration = "fl_plantlife:grass_" .. i
    })
end

for _, flower in pairs(fl_plantlife.decoration_flowers) do
    minetest.register_decoration({
        name = flower .. "_coniferousforest",
        deco_type = "simple",
        place_on = {"fl_topsoil:dirt_with_grass"},
        sidelen = 16,
        fill_ratio = 0.001,
        biomes = {"coniferousforest"},
        y_max = 300,
        y_min = 4,
        param2 = 1,
        param2_max = 255,
        decoration = flower,
    })
    minetest.register_decoration({
        name = flower .. "_rare",
        deco_type = "simple",
        place_on = {"fl_topsoil:dirt_with_grass"},
        sidelen = 16,
        fill_ratio = 0.0001,
        biomes = {"grassland", "deciduousforest"},
        y_max = 300,
        y_min = 4,
        param2 = 1,
        param2_max = 255,
        decoration = flower,
    })
end

minetest.register_decoration({
    name = "fl_plantlife:cactus",
    deco_type = "schematic",
    place_on = {"fl_stone:sand"},
    sidelen = 16,
    fill_ratio = 0.0001,
    biomes = {"sand"},
    y_max = 300,
    y_min = 4,
    schematic = {
        --for some reason first one never exists?
        size = {x=1, y=4, z=1},
        data = {
            {name = "fl_plantlife:cactus"},
            {name = "fl_plantlife:cactus"},
            {name = "fl_plantlife:cactus"},
            {name = "fl_plantlife:cactus"},
        },
        yslice_prob = {
            {ypos = 3, prob = 160}
        }
    }
})

for i = 1, 3 do
    minetest.register_decoration({
        name = "fl_topsoil:sea_grass_" .. i,
        deco_type = "simple",
        place_on = {"fl_stone:sand"},
        sidelen = 16,
        fill_ratio = 0.06,
        --biomes = {"grassland", "deciduousforest"},
        place_offset_y = -1,
        y_max = 0,
        y_min = -16,
        param2 = 0,
        param2_max = 4,
        flags = "force_placement",
        decoration = "fl_topsoil:sea_grass_" .. i
    })
end