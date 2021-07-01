fl_wildlife = {}
fl_brains = {}

fl_wildlife.details = {
    version = 11,
    name = "fl_wildlife",
    author = "wsor",
    license = "MIT",
}

fl_brains.details = fl_wildlife.details

local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath .. "/api.lua")
dofile(modpath .. "/node_items.lua")
dofile(modpath .. "/crafts.lua")

local mob_brains = {
    "villager_brain",
    "fish_brain",
}

local mob_list = {
    "villager",
    "trader",
    "riverfish",
    --"mimic",
    "sheep",
    "chicken",
    "cow",
}

for _, brain in pairs(mob_brains) do
    dofile(modpath .. "/fl_brains/" .. brain .. ".lua")
end

for _, mob in pairs(mob_list) do
    local setting = "fl_wildlife." .. mob .. ".enable"
    if minetest.settings:get_bool(setting, true) == true then
        dofile(modpath .. "/fl_mobs/" .. mob .. ".lua")
    end
end

dofile(modpath .. "/spawner.lua")