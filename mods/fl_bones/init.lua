minetest.register_craftitem("fl_bones:bonemeal", {
    description = "bonemeal",
    inventory_image = "farlands_bonemeal.png",
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then return end
        local node = minetest.get_node_or_nil(pointed_thing.under)
        if not node then return end
        if minetest.get_item_group(node.name, "plant") ~= 1 then return end

        local node_def = minetest.registered_nodes[node.name]
        if node_def._on_bonemeal then
            node_def._on_bonemeal(pointed_thing.under, user)
            itemstack:take_item()
            return itemstack
        end
        if minetest.get_node_timer(pointed_thing.under):is_started() then
            if math.random(10) > 8 then
                minetest.get_node_timer(pointed_thing.under):stop()
                node_def.on_timer(pointed_thing.under, 0)
            end
            itemstack:take_item()
            return itemstack
        end
        return
    end
})