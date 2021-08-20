fl_stone = {}
fl_stone.details = {
    version = 1,
    name = "fl_stone",
    author = "wsor",
    license = "MIT",
}

local modpath = minetest.get_modpath("fl_stone")
dofile(modpath .. "/sounds.lua")
dofile(modpath .. "/stone.lua")
dofile(modpath .. "/sand.lua")
dofile(modpath .. "/other.lua")