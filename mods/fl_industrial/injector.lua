minetest.register_node("fl_industrial:injector", {
    description = "injector",
    tiles = {
        "farlands_conveyor_base.png",
        "farlands_conveyor_base.png",
        "farlands_conveyor_base.png^farlands_injector_arrow.png",
        "farlands_conveyor_base.png^(farlands_injector_arrow.png^[transformR180)",
        --"[combine:16x16",
        --"[combine:16x16",
        "farlands_conveyor_base.png",
        "farlands_conveyor_base.png",
    },
    paramtype2 = "facedir",
    _item_input = function(pos, node, itemstack)
        --minetest.chat_send_all(minetest.pos_to_string(pos, 2))
        local dir = core.facedir_to_dir(node.param2)
        local inv = minetest.get_inventory({type = "node", pos = vector.add(pos, dir)})
        local inv_node = minetest.get_node(vector.add(pos, dir))
        local def = minetest.registered_nodes[inv_node.name]

        local dump
        if def.allow_metadata_inventory_put
            and def.allow_metadata_inventory_put(vector.add(pos, dir), "main", 1, itemstack, nil) == 0 or not inv then
            dump = itemstack
        else
            dump = inv:add_item("main", itemstack)
        end
        if not dump:is_empty() then minetest.add_item(vector.new(pos.x, pos.y+1, pos.z), dump) end

    end,
    _allow_input = function(np2, op2)
        if np2 == op2 then return true end
    end,
    groups = {oddly_breakable_by_hand = 3, item_input = 1}
})