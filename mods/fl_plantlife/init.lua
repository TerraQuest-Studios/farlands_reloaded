fl_plantlife = {}
local modpath = minetest.get_modpath("fl_plantlife")

dofile(modpath .. "/grass.lua")
dofile(modpath .. "/cactus.lua")
dofile(modpath .. "/mushrooms.lua")
dofile(modpath .. "/flowers.lua")
dofile(modpath .. "/flowerpot.lua")

fl_plantlife.init = true