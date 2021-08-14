--this code is a mess
-- -150 to -190 seems no ores other than mithite???

biomes = {
    savannah = {"savannah"},
    stone = {"grassland", "taiga", "snowygrassland", "tundra", "rainforest", "deciduousforest", "coniferousforest"},
    desert_stone = {"sand", "desert", "silversand"},
    ors = {"ors"},
    tuff = {"tuff"},
}

for name, data in pairs(biomes) do
    local temp = {}
    for _, biome in pairs(data) do
        table.insert(temp, biome)
        table.insert(temp, biome .. "_ocean")
    end
    biomes[name] = table.copy(temp)
end

minetest.register_ore({
    ore_type = "scatter",
    ore = "fl_ores:mithite_in_stone",
    wherein = "fl_stone:stone",
    clust_scarcity = 30*30*30,
    clust_num_ores = 1,
    clust_size = 1,
    y_max = 32,
    y_min = -32,
})
minetest.register_ore({
    ore_type = "scatter",
    ore = "fl_ores:mithite_in_ors",
    wherein = "fl_stone:ors",
    clust_scarcity = 30*30*30,
    clust_num_ores = 1,
    clust_size = 1,
    y_max = -32,
    y_min = -150,
})
minetest.register_ore({
    ore_type = "scatter",
    ore = "fl_ores:mithite_in_tuff",
    wherein = "fl_stone:tuff",
    clust_scarcity = 30*30*30,
    clust_num_ores = 1,
    clust_size = 1,
    y_max = -150,
    y_min = -300,
})

local function reg_ores(ore, clust)
    for name, data in pairs(biomes) do
        local scr = clust[name].scr
        local ost = clust[name].ost or {300,4,64,-31,3,-31}
        minetest.register_ore({
            ore_type = "scatter",
            ore = "fl_ores:" .. ore .. "_in_" .. name,
            wherein = "fl_stone:" .. name,
            clust_scarcity = (scr+3) * (scr+3) * (scr+3),
            clust_num_ores = clust[name].nmo+1,
            clust_size = clust[name].sz+1,
            biomes = biomes[name],
            y_max = ost[1], --300
            y_min = ost[2], --4
        })

        minetest.register_ore({
            ore_type = "scatter",
            ore = "fl_ores:" .. ore .. "_in_" .. name,
            wherein = "fl_stone:" .. name,
            clust_scarcity = (scr) * (scr) * (scr),
            clust_num_ores = clust[name].nmo,
            clust_size = clust[name].sz,
            biomes = biomes[name],
            y_max = ost[3], --64
            y_min = ost[4], -- -31
        })

        minetest.register_ore({
            ore_type = "scatter",
            ore = "fl_ores:" .. ore .. "_in_" .. name,
            wherein = "fl_stone:" .. name,
            clust_scarcity = (scr+10) * (scr+10) * (scr+10),
            clust_num_ores = clust[name].nmo+4,
            clust_size = clust[name].sz+4,
            biomes = biomes[name],
            y_max = ost[5], --3
            y_min = ost[6], -- -31
        })
    end
end

reg_ores("coal", {
    stone = {scr = 7, nmo = 7, sz = 3},
    savannah = {scr = 6, nmo = 8, sz = 4},
    desert_stone = {scr = 8, nmo = 6, sz = 2}, ----21,45,1698
    ors = {scr = 9, nmo = 4, sz = 3, ost = {-300,-300,-31,-50,-31,-100,}},
    tuff = {scr = 30, nmo = 1, sz = 1, ost = {-300,-300,-150,-300,-300,-300}},
})

reg_ores("iron", {
    stone = {scr = 12, nmo = 7, sz = 3},
    savannah = {scr = 18, nmo = 8, sz = 4},
    desert_stone = {scr = 16, nmo = 6, sz = 2},
    ors = {scr = 19, nmo = 4, sz = 3, ost = {-300,-300,-31,-75,-31,-125,}},
    tuff = {scr = 30, nmo = 1, sz = 1, ost = {-300,-300,-150,-300,-300,-300}},
})

reg_ores("copper", {
    stone = {scr = 18, nmo = 8, sz = 3, ost = {-31,-31,0,-31,-20,-31}},
    savannah = {scr = 14, nmo = 6, sz = 4, ost = {-31,-31,0,-31,-20,-31}},
    desert_stone = {scr = 16, nmo = 6, sz = 2, ost = {-31,-31,0,-31,-20,-31}},
    ors = {scr = 19, nmo = 7, sz = 3, ost = {-31,-50,-31,-100,-31,-125,}},
    tuff = {scr = 30, nmo = 1, sz = 1, ost = {-300,-300,-150,-300,-300,-300}},
})

reg_ores("tin", {
    stone = {scr = 18, nmo = 7, sz = 3, ost = {-31,-31,-10,-31,-20,-31}},
    savannah = {scr = 20, nmo = 8, sz = 4, ost = {-31,-31,-10,-31,-20,-31}},
    desert_stone = {scr = 16, nmo = 6, sz = 2, ost = {-31,-31,-10,-31,-20,-31}},
    ors = {scr = 21, nmo = 7, sz = 3, ost = {-31,-50,-31,-100,-31,-150,}},
    tuff = {scr = 30, nmo = 1, sz = 1, ost = {-300,-300,-150,-300,-300,-300}},
})

reg_ores("gold", {
    stone = {scr = 30, nmo = 1, sz = 1, ost = {-300,-300,-10,-31,-300,-300}},
    savannah = {scr = 30, nmo = 1, sz = 1, ost = {-300,-300,-10,-31,-300,-300}},
    desert_stone = {scr = 30, nmo = 1, sz = 1, ost = {-300,-300,-10,-31,-300,-300}},
    ors = {scr = 18, nmo = 7, sz = 3, ost = {-75,-150,-31,-150,-50,-150,}},
    tuff = {scr = 18, nmo = 7, sz = 3, ost = {-150,-250,-150,-300,-150,-275}},
})

reg_ores("diamond", {
    stone = {scr = 30, nmo = 1, sz = 1, ost = {-300,-300,-10,-31,-300,-300}},
    savannah = {scr = 30, nmo = 1, sz = 1, ost = {-300,-300,-10,-31,-300,-300}},
    desert_stone = {scr = 30, nmo = 1, sz = 1, ost = {-300,-300,-10,-31,-300,-300}},
    ors = {scr = 18, nmo = 7, sz = 3, ost = {-75,-150,-31,-150,-50,-150,}},
    tuff = {scr = 18, nmo = 7, sz = 3, ost = {-150,-300,-150,-300,-150,-300}},
})