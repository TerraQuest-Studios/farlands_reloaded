--bedrock and snow layers are in mapgen_async.lua

--start cactus timers
local cactus_did = core.get_decoration_id("fl_plantlife:cactus")
core.set_gen_notify("decoration", {cactus_did})

core.register_on_generated(function()
    local g = core.get_mapgen_object("gennotify")
    local locations = g["decoration#" .. cactus_did] or {}
    if #locations == 0 then return end
    for _, pos in ipairs(locations) do
        for i=1, 3 do
            local node = core.get_node_or_nil({x=pos.x, y=pos.y+i, z=pos.z})
            if not node then return end
            if node.name == "fl_plantlife:cactus" then
                local timer = core.get_node_timer({x=pos.x, y=pos.y+i, z=pos.z})
                timer:start(math.random(600, 1200))
            end
        end
    end
end)