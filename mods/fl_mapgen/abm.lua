minetest.register_abm({
    labal = "lava to stone",
    nodenames = {"fl_liquids:lava_source", "fl_liquids:lava_flowing"},
    neighbors = {"group:water"},
    interval = 2,
    chance = 1,
    catch_up = false;
    action = function(pos, node)
        minetest.set_node(pos, {name = "fl_stone:stone"})
    end,
})

minetest.register_abm({
    labal = "lava to basalt",
    nodenames = {"fl_liquids:lava_source", "fl_liquids:lava_flowing"},
    neighbors = {"fl_topsoil:condensed_ice"},
    interval = 2,
    chance = 1,
    catch_up = false;
    action = function(pos, node)
        minetest.set_node(pos, {name = "fl_stone:basalt"})
    end,
})

--[[
minetest.register_abm({
    labal = "melts",
    --nodenames = {"fl_liquids:lava_source", "fl_liquids:lava_flowing"},
    --neighbors = {"group:melts"},
    nodenames = {"group:melts"},
    neighbors = {"fl_liquids:lava_source", "fl_liquids:lava_flowing"},
    interval = 2,
    chance = 2,
    catch_up = false;
    action = function(pos, node)
        minetest.set_node(pos, {name = "fl_liquids:water_source"})
    end,
})
--]]