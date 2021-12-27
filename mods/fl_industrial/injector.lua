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
    on_punch = function(pos, node, puncher, pointed_thing)
        --handle register_on_punchnode stuff
        minetest.node_punch(pos, node, puncher, pointed_thing)

        local dir = core.facedir_to_dir(node.param2)
        local inv = minetest.get_inventory({type = "node", pos = vector.subtract(pos, dir)})
        local inv_node = minetest.get_node(vector.subtract(pos, dir))

        if inv and not inv:is_empty("main") then
            local list = inv:get_list("main")
            for i = inv:get_size("main"),1,-1 do
                if not list[i]:is_empty() then
                    if inv_node.allow_metadata_inventory_take and
                    inv_node.allow_metadata_inventory_take(vector.subtract(pos, dir), "main", i, list[i], nil) ~= 0 then
                        return
                    end
                    minetest.add_item(vector.add(pos, dir), list[i])
                    list[i]:clear()
                    inv:set_list("main", list)
                    return
                end
            end
        end
    end,
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