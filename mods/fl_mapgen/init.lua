local modpath = minetest.get_modpath("fl_mapgen")

dofile(modpath .. "/aliases.lua")
dofile(modpath .. "/abm.lua")

dofile(modpath .. "/biomes.lua")
--must be after biomes
dofile(modpath .. "/biome_sky.lua")
dofile(modpath .. "/ores.lua")
dofile(modpath .. "/trees.lua")
dofile(modpath .. "/decorations.lua")
dofile(modpath .. "/dungeon/init.lua")

--at the end as this contains register_on_generateds
dofile(modpath .. "/other.lua")