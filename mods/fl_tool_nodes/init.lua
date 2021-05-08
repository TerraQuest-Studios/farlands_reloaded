local modpath = minetest.get_modpath("fl_tool_nodes")

local tool_nodes = {
    "saw",
    --"furnace",
}

for _, tool in pairs(tool_nodes) do
    dofile(modpath .. "/" .. tool .. ".lua")
end