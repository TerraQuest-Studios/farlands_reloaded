core.register_craftitem("fl_agriculture:potato", {
    description = "potato",
    inventory_image = "farlands_potato.png",
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then return end
        local pos = pointed_thing.under
        local node = core.get_node_or_nil(pos)
        local anode = core.get_node_or_nil({x=pos.x, y=pos.y+1,z=pos.z})
        if not node then return end
        if not anode then return end
        if not core.registered_nodes[node.name] then return end
        if not core.registered_nodes[anode.name] then return end
        if core.get_item_group(node.name, "plantable") ~= 1 then return end
        if core.registered_nodes[anode.name].drawtype ~= "airlike" then return end
        core.set_node({x=pos.x, y=pos.y+1,z=pos.z}, {name = "fl_agriculture:potato_1", param2 = 3})
        if not (placer and placer:is_player()
            and core.is_creative_enabled(placer:get_player_name()))
        then
            itemstack:take_item()
        end
        return itemstack
    end,
    _dungeon_loot = {name = "fl_agriculture:potato", chance = 0.6, count = {3, 6}},
    on_use = core.item_eat(4)
})

for i = 1, 4 do
    local drop = "fl_agriculture:potato"
    if i == 4 then
        drop = {
            items = {
                {items = {"fl_agriculture:potato"}}, {items = {"fl_agriculture:potato"}, rarity = 2},
                {items = {"fl_agriculture:potato"}, rarity = 2}, {items = {"fl_agriculture:potato"}, rarity = 2},
            }
        }
    end
    core.register_node("fl_agriculture:potato_" .. i, {
        description = "potato crop",
        drawtype = "plantlike",
        paramtype = "light",
        paramtype2 = "meshoptions",
        place_param2 = 3,
        tiles = {"[combine:16x16:0," .. 12 - 3*i .. "=farlands_potato_crop.png"},
        sunlight_propagates = true,
        walkable = false,
        selection_box = {
            type = "fixed",
            fixed = {{-0.5, -0.5, -0.5, 0.5, 2/16-0.5, 0.5}}
        },
        buildable_to = true,
        floodable = true,
        on_flood = function(pos, oldnode, newnode)
            core.dig_node(pos)
        end,
        on_construct = function(pos)
            if i == 4 then return end
            core.get_node_timer(pos):start(math.random(150, 450))
        end,
        on_timer = function(pos, elapsed)
            local old = core.get_node(pos)
            local dirt = core.get_node({x = pos.x, y = pos.y-1, z = pos.z})
            if dirt.name=="fl_topsoil:wet_farmland" and core.get_node_light(pos, core.get_timeofday())>9 then
                core.swap_node(pos, {
                    name = "fl_agriculture:potato_" .. i+1,
                    param1 = old.param1,
                    param2 = old.param2
                })
            else
                core.get_node_timer(pos):start(math.random(150, 450))
                return
            end
            if i+1 ~= 4 then
                core.get_node_timer(pos):start(math.random(150, 450))
            end
        end,
        drop = drop,
        groups = {oddly_breakable_by_hand = 3, not_in_creative_inventory = 1, plant = 1},
    })
end