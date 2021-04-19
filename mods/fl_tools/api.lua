fl_tools.stripped_on_use = function(itemstack, placer, pointed_thing)
    if pointed_thing.type ~= "node" then return end

    local node = minetest.get_node(pointed_thing.under)
    local node_def = minetest.registered_nodes[node.name]

    if placer and not placer:get_player_control().sneak then
        if node_def.on_rightclick then
            return node_def.on_rightclick(pointed_thing.under, node, placer, itemstack)
        end
    end
    if minetest.is_protected(pointed_thing.under, placer:get_player_name()) then
        minetest.record_protection_violation(pointed_thing.under, placer:get_player_name())
        return itemstack
    end
    if node_def._stripped_varient == nil then
        return itemstack
    else
        minetest.swap_node(pointed_thing.under, {name=node_def._stripped_varient, param2=node.param2})
    end
end