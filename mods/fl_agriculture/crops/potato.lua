minetest.register_craftitem("fl_agriculture:potato", {
    description = "potato",
    inventory_image = "farlands_potato.png",
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then return end
        local pos = pointed_thing.under
        local node = minetest.get_node_or_nil(pos)
        local anode = minetest.get_node_or_nil({x=pos.x, y=pos.y+1,z=pos.z})
        if not node then return end
        if not anode then return end
        if not minetest.registered_nodes[node.name] then return end
        if not minetest.registered_nodes[anode.name] then return end
        if minetest.get_item_group(node.name, "plantable") ~= 1 then return end
        if minetest.registered_nodes[anode.name].drawtype ~= "airlike" then return end
        minetest.place_node({x=pos.x, y=pos.y+1,z=pos.z}, {name = "fl_agriculture:potato_1"})
        itemstack:take_item()
        return itemstack
    end,
    on_use = minetest.item_eat(4)
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
    minetest.register_node("fl_agriculture:potato_" .. i, {
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
            minetest.dig_node(pos)
        end,
        on_construct = function(pos)
            if i == 4 then return end
            minetest.get_node_timer(pos):start(math.random(150, 450))
        end,
        on_timer = function(pos, elapsed)
            local old = minetest.get_node(pos)
            local dirt = minetest.get_node({x = pos.x, y = pos.y-1, z = pos.z})
            if dirt.name=="fl_topsoil:wet_farmland" and minetest.get_node_light(pos, minetest.get_timeofday())>9 then
                minetest.swap_node(pos, {
                    name = "fl_agriculture:potato_" .. i+1,
                    param1 = old.param1,
                    param2 = old.param2
                })
            else
                minetest.get_node_timer(pos):start(math.random(150, 450))
                return
            end
            if i+1 ~= 4 then
                minetest.get_node_timer(pos):start(math.random(150, 450))
            end
        end,
        drop = drop,
        groups = {oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
    })
end