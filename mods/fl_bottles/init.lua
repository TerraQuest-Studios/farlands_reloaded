minetest.register_craftitem("fl_bottles:water", {
    description = "bottle with water",
    inventory_image = "farlands_bottle_blue.png",
    groups = {bottle = 1, vessel = 1},
})

minetest.register_craftitem("fl_bottles:river_water", {
    description = "bottle with river water",
    inventory_image = "farlands_bottle_aqua.png",
    groups = {bottle = 1, vessel = 1},
})

minetest.register_craftitem("fl_bottles:bottle", {
    description = "empty bottle",
    inventory_image = "farlands_bottle_empty.png",
    liquids_pointable = true,
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then return end

        local node = minetest.get_node(pointed_thing.under)
        local node_def = minetest.registered_nodes[node.name]

        if user and not user:get_player_control().sneak then
            if node_def.on_rightclick then
                return node_def.on_rightclick(pointed_thing.under, node, user, itemstack)
            end
        end

        if node_def._bottle_item == nil then
            return itemstack
        else
            if user:get_wielded_item():get_count() > 1 then
                local inv = user:get_inventory()
                if inv:room_for_item("main", {name=node_def._bottle_item}) then
                    inv:add_item("main", node_def._bottle_item)
                else
                    local pos = user:get_pos()
                    pos.y = math.floor(pos.y + 0.5)
                    minetest.add_item(pos, node_def._bottle_item)
                end
                itemstack:take_item()
                return itemstack
            end
            return ItemStack(node_def._bottle_item)
        end
    end,
    groups = {bottle = 1, vessel = 1},
})

minetest.register_craft({
    type = "shapeless",
    output = "fl_bottles:bottle 16",
    recipe = {"group:glass_block"}
})

minetest.register_craft({
    type = "shapeless",
    output = "fl_bottles:bottle",
    recipe = {"group:glass_pane"}
})

minetest.register_craftitem("fl_bottles:invisibility", {
    description = "bottle of invisibilty",
    inventory_image = "farlands_bottle_darkpurple.png",
    --on_use throw, particles, anyone nearby gets invisibility
    on_place = function(itemstack, placer, pointed_thing)
        if placer:get_meta():get_int("in_vanish") > 0 then return itemstack end
        local pname = placer:get_player_name()
        placer:get_meta():set_int("vanish", 1)
        placer:get_meta():set_int("in_vanish", 1)
        placer:set_properties({
            visual_size = {x = 0, y = 0, z = 0},
            is_visible = false,
            show_on_minimap = false,
            selectionbox = {0, 0, 0, 0, 0, 0},
        })
        placer:set_nametag_attributes({color = {a = 0, r = 255, g = 255, b = 255}})

        minetest.after(60,
            function()
                --minetest.chat_send_all("after")
                if minetest.get_player_by_name(pname) then
                    local player = minetest.get_player_by_name(pname)
                    player:get_meta():set_int("vanish", 0)
                    player:get_meta():set_int("in_vanish", 0)
                    player:set_properties({
                        visual_size = {x = 1, y = 1, z = 1},
                        is_visible = true,
                        show_on_minimap = true,
                        selectionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
                    })
                    player:set_nametag_attributes({color = {a = 255, r = 255, g = 255, b = 255}})
                end
            end
        )

        if not (placer and placer:is_player()
            and minetest.is_creative_enabled(placer:get_player_name()))
        then
            itemstack:take_item()
        end
        return itemstack
    end,
})

minetest.register_on_leaveplayer(function(player, _)
    player:get_meta():set_int("vanish", 0)
    player:get_meta():set_int("in_vanish", 0)
end)

minetest.register_on_shutdown(function()
    for _, player in pairs(minetest.get_connected_players()) do
        player:get_meta():set_int("vanish", 0)
        player:get_meta():set_int("in_vanish", 0)
    end
end)