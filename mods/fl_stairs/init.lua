--note that this does not support hardware coloring as well as some other stuff
fl_stairs = {}

fl_stairs.details = {
    version = 5,
    name = "fl_stairs",
    author = "wsor",
    license = "MIT",
}

local stairtable = {
    {
        "slab",
        {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
    },
    {
        "stair",
        {
            {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
            {-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
        },
    },
    {
        "inner_stair",
        {
            {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
            {-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
            {-0.5, 0.0, -0.5, 0.0, 0.5, 0.0},
        },
    },
    {
        "outer_stair",
        {
            {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
            {-0.5, 0.0, 0.0, 0.0, 0.5, 0.5},
        },
    },
}

local function slab_onplace(itemstack, placer, pointed_thing)
    if pointed_thing.type ~= "node" then return itemstack end

    if minetest.get_node(pointed_thing.under).name == itemstack:get_name()
    and not placer:get_player_control().sneak then
        minetest.set_node(pointed_thing.under, {name=string.sub(itemstack:get_name(), 1, -6)})
        if minetest.is_creative_enabled(placer:get_player_name()) == false then
            itemstack:take_item()
        end
        return itemstack
    end
    minetest.rotate_and_place(itemstack, placer, pointed_thing, true, {force_facedir = true}, true)
end

local function sstiles(nodedef, dtype)
    local t = nodedef.tiles[dtype] or nodedef.tiles
    if string.sub(nodedef.drawtype, 1, 5) == "glass" and t[2] then
        local j = {{name = t[1] .. "^" .. t[2]}}
        j[1].align_style = nodedef._disable_worldaligned and "node" or "world"
        return j
    end
    for i = 1, #t do
        if type(t[i]) == "string" then
            t[i] = {name = t[i]}
        end
        t[i].align_style = nodedef._disable_worldaligned and "node" or "world"
    end
    return t
end

function fl_stairs.register_stairslab(itemstring)
    local nodedef = minetest.registered_nodes[itemstring]

    local paramtype2 = "facedir"
    if nodedef.palette then paramtype2 = "colorfacedir" end

    for _, stairinfo in pairs(stairtable) do

        local regnode = itemstring .. "_" .. stairinfo[1]
        local groups = table.copy(nodedef.groups)
        groups[stairinfo[1]] = 1
        groups["all_nodes"] = 1
        groups.stairable, groups.wallable, groups.not_in_creative_inventory, groups.not_blocking_trains = nil, nil, 1, 1

        minetest.register_node(":" .. regnode, {
            description = nodedef.description .. " " .. stairinfo[1],
            tiles = sstiles(nodedef, "_" .. stairinfo[1]),
            paramtype = "light",
            paramtype2 = paramtype2,
            palette = nodedef.palette,
            use_texture_alpha = nodedef.use_texture_alpha,
            drawtype = "nodebox",
            node_box = {
                type = "fixed",
                fixed = stairinfo[2],
            },
            on_place = function(itemstack, placer, pointed_thing)
                if stairinfo[1] == "slab" then
                    slab_onplace(itemstack, placer, pointed_thing)
                else
                    minetest.rotate_node(itemstack, placer, pointed_thing)
                end
            end,
            drop = nodedef.drop and nodedef.drop.stairs and nodedef.drop.stairs[stairinfo[1]],
            groups = groups,
        })
    end
end

function fl_stairs.register_wall(itemstring)
    local nodedef = minetest.registered_nodes[itemstring]
    local groups = table.copy(nodedef.groups)
    groups.stairable, groups.wallable, groups.wall, groups.not_in_creative_inventory = nil, nil, 1, 1
    groups.all_nodes, groups.spawn_blacklist = 1, 1

    minetest.register_node(":" .. itemstring .. "_wall", {
        description = nodedef.description .. " wall",
        tiles = nodedef.tiles,
        paramtype = "light",
        drawtype = "nodebox",
        node_box = {
            type = "connected",
            fixed = {-1/4, -1/2, -1/4, 1/4, 1/2, 1/4},
            connect_front = {-3/16, -1/2, -1/2,  3/16, 3/8, -1/4},
            connect_left = {-1/2, -1/2, -3/16, -1/4, 3/8,  3/16},
            connect_back = {-3/16, -1/2,  1/4,  3/16, 3/8,  1/2},
            connect_right = { 1/4, -1/2, -3/16,  1/2, 3/8,  3/16},
        },
        connects_to = {"group:wall", "group:wood_related", "group:stonelike"},
        drop = nodedef.drop and nodedef.drop.walls,
        groups = groups,
    })
end

--registered_nodes should work, however it was not finding fl_stone:stone for some reason
--[[
minetest.register_on_mods_loaded(function()
    for _, node in pairs(minetest.registered_items) do
        if node.groups.stairable == 1 then
            fl_stairs.register_stairslab(node.name)
        end
        if node.groups.wallable == 1 then
            fl_stairs.register_wall(node.name)
        end
    end
end)
--]]

minetest.register_on_mods_loaded(function()
    --minetest.after(0, function()
        minetest.log("error", "stair loop starting!!!")
        local registered_items_copy = table.copy(minetest.registered_items)
        for nodename, node in pairs(registered_items_copy) do
            if string.find(nodename, "fl_stone") then
                minetest.log("error", nodename)
            end
            if nodename == "fl_stone:basalt_block" then
                minetest.log("error", "basalt node found")
                minetest.log("error", dump(node))
            end
            if node.groups.stairable == 1 then
                if node.name == "fl_stone:basalt_block" then
                    minetest.log("error", "basalt node stair function calling")
                end

                fl_stairs.register_stairslab(node.name)
            end
            if node.groups.wallable == 1 then
                fl_stairs.register_wall(node.name)
            end
        end
    --end)
end)