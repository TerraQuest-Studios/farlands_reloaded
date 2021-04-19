fl_tools = {}

fl_tools.details = {
    version = 1,
    name = "fl_tools",
    author = "wsor",
    license = "MIT",
}

local modpath = minetest.get_modpath("fl_tools")
dofile(modpath .. "/api.lua")
dofile(modpath .. "/tool_sets.lua")
dofile(modpath .. "/other_tools.lua")
