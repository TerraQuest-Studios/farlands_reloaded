fl_wildlife = {}

fl_wildlife.details = {
    version = 11,
    name = "fl_wildlife",
    author = "wsor",
    license = "MIT",
}

local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath .. "/api.lua")
dofile(modpath .. "/node_items.lua")
dofile(modpath .. "/crafts.lua")
dofile(modpath .. "/commands.lua")

local mob_list = {
    "villager",
    "trader",
    "riverfish",
    --"mimic",
    "sheep",
    "chicken",
    "cow",
    "cavecrab",
    "elephant",
}

for _, mob in pairs(mob_list) do
    dofile(modpath .. "/fl_mobs/" .. mob .. ".lua")
end

dofile(modpath .. "/spawner.lua")
dofile(modpath .. "/spawning.lua")