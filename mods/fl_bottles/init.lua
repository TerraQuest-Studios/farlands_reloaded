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