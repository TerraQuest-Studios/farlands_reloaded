fl_topsoil = {}

local modpath = minetest.get_modpath("fl_topsoil")

dofile(modpath .. "/sounds.lua")
--dofile(modpath .. "/stones.lua")
--dofile(modpath .. "/ores.lua")
--dofile(modpath .. "/liquids.lua")
dofile(modpath .. "/topsoil.lua")
--dofile(modpath .. "/other.lua")
dofile(modpath .. "/crafts.lua")

minetest.register_abm({
    label = "agriculture soil conversion",
    nodenames = {"group:farmland"},
    interval = 5,
    chance = 2,
    action = function(pos, node)
        if minetest.find_node_near(pos, 3, {"group:water"}) then
            if string.find(node.name, "dry") then
                minetest.swap_node(pos, {name = "fl_topsoil:wet_farmland"})
            end
        elseif string.find(node.name, "wet") then
            minetest.swap_node(pos, {name = "fl_topsoil:dry_farmland"})
        end
    end,
})

fl_topsoil.init = true