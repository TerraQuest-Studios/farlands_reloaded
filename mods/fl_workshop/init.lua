local modpath = minetest.get_modpath("fl_workshop")

fl_workshop = {}

fl_workshop.details = {
    version = 3,
    name = "fl_workshop",
    author = "wsor",
    license = "MIT",
}

local tool_nodes = {
    "saw",
    "furnace",
    "anvil",
}

for _, tool in pairs(tool_nodes) do
    dofile(modpath .. "/" .. tool .. ".lua")
end