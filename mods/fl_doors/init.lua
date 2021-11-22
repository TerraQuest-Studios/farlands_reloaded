minetest.register_node("fl_doors:blocker_top", {
    description = "door top blocker",
    drawtype = "airlike",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = true,
    pointable = false,
    diggable = false,
    buildable_to = false,
    floodable = false,
    on_blast = function() end,
    collision_box = {
        type = "fixed",
        fixed = {-15/32, 13/32, -15/32, -13/32, 1/2, -13/32},
    },
    groups = {not_in_creative_inventory = 1}
})

local function make_door(file, modname, append)
    local split = file:split(".")
    local name = split[1]:sub(10, #split[1])
    local material = split[1]:sub(10, #file-9)

    minetest.register_node("fl_doors:" .. name .. "_a", {
        description = name:gsub("_", " "),
        drawtype = "mesh",
        paramtype = "light",
        paramtype2 = "facedir",
        mesh = "farlands_door_a.b3d",
        use_texture_alpha = "clip",
        tiles = {file},
        wield_image = file:gsub("door", "door_item"),
        inventory_image = file:gsub("door", "door_item"),
        selection_box = {type = "fixed", fixed = {-1/2,-1/2,-1/2,1/2,3/2,-6/16}},
        collision_box = {type = "fixed", fixed = {-1/2,-1/2,-1/2,1/2,3/2,-6/16}},
        on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
            local p2 = node.param2+1
            if p2 == 4 then p2 = 0 end
            minetest.set_node(pos, {name = "fl_doors:" .. name .. "_b", param2 = p2})
        end,
        on_place = function(itemstack, placer, pointed_thing)
            if pointed_thing.type ~= "node" then return end
            local node = minetest.get_node(pointed_thing.under)
            local def = minetest.registered_nodes[node.name]
            if def and def.on_rightclick
            and not (placer and placer:is_player() and placer:get_player_control().sneak) then
                return def.on_rightclick(pointed_thing.under, node, placer, itemstack, pointed_thing)
            end
            local dpos = pointed_thing.above--vector.new(pos.x, pos.y+1, pos.z)
            local anode = minetest.get_node(vector.new(dpos.x, dpos.y+1, dpos.z))
            local adef = minetest.registered_nodes[anode.name]
            if adef and adef.drawtype == "airlike" then
                local dir = placer and minetest.dir_to_facedir(placer:get_look_dir()) or 0

                local ref = {
                    {x = -1, y = 0, z = 0},
                    {x = 0, y = 0, z = 1},
                    {x = 1, y = 0, z = 0},
                    {x = 0, y = 0, z = -1},
                }

                local aside = {
                    x = dpos.x + ref[dir + 1].x,
                    y = dpos.y + ref[dir + 1].y,
                    z = dpos.z + ref[dir + 1].z,
                }

                if minetest.get_item_group(minetest.get_node(aside).name, "door") == 1 then
                    minetest.set_node(dpos, {name = "fl_doors:" .. name .. "_b", param2 = dir})
                    minetest.set_node(vector.new(dpos.x, dpos.y+1, dpos.z), {name = "fl_doors:blocker_top"})
                else
                    minetest.set_node(dpos, {name = "fl_doors:" .. name .. "_a", param2 = dir})
                    minetest.set_node(vector.new(dpos.x, dpos.y+1, dpos.z), {name = "fl_doors:blocker_top"})
                end
            end
        end,
        after_dig_node = function(pos, node, meta, digger)
            minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
            minetest.check_for_falling({x = pos.x, y = pos.y + 1, z = pos.z})
        end,
        groups = {dig_tree = 2, door = 1},
    })

    minetest.register_node("fl_doors:" .. name .. "_b", {
        description = name:gsub("_", " "),
        drawtype = "mesh",
        paramtype = "light",
        paramtype2 = "facedir",
        mesh = "farlands_door_b.b3d",
        use_texture_alpha = "clip",
        tiles = {file},
        selection_box = {type = "fixed", fixed = {-1/2,-1/2,-1/2,1/2,3/2,-6/16}},
        collision_box = {type = "fixed", fixed = {-1/2,-1/2,-1/2,1/2,3/2,-6/16}},
        wield_image = file:gsub("door", "door_item"),
        inventory_image = file:gsub("door", "door_item"),
        on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
            local p2 = node.param2-1
            if p2 == -1 then p2 = 3 end
            minetest.set_node(pos, {name = "fl_doors:" .. name .. "_a", param2 = p2})
        end,
        after_dig_node = function(pos, node, meta, digger)
            minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
            minetest.check_for_falling({x = pos.x, y = pos.y + 1, z = pos.z})
        end,
        drop = "fl_doors:" .. name .. "_a",
        groups = {dig_tree = 2, door = 1, not_in_creative_inventory = 1},
    })

    if material == "steel" then material = "iron" end
    local cm = modname .. ":" .. material .. append
    minetest.register_craft({
        output = "fl_doors:" .. name .. "_a",
        recipe = {
            {cm, cm},
            {cm, cm},
            {cm, cm},
        }
    })

    return "fl_doors:" .. name .. "_a"
end

local door_list = {}
local pdir = minetest.get_dir_list(minetest.get_modpath("fl_doors") .. "/textures/planks", false)
local mdir = minetest.get_dir_list(minetest.get_modpath("fl_doors") .. "/textures/metal", false)

for _, file in pairs(pdir) do
    if not file:find("item") then table.insert(door_list, make_door(file, "fl_trees", "_plank")) end
end

for _, file in pairs(mdir) do
    if not file:find("item") then table.insert(door_list, make_door(file, "fl_ores", "_ingot")) end
end

if minetest.get_modpath("i3") then
    local item = door_list[#door_list]
    door_list[#door_list] = nil
    local material = {}

    for _, door in pairs(door_list) do
        local split = door:split(":")
        local split2 = split[2]:split("_")
        if split2[1] == "yellow" then split2[1] = "yellow_ipe" end
        table.insert(material, split2[1])
    end

    local split = item:split(":")
    local split2 = split[2]:split("_")

    i3.compress(item, {
        replace = split2[1],
        by = material
    })
end