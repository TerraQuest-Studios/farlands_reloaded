local function bucket_on_place(itemstack, user, pointed_thing, liquid_source)
    local pos

    if pointed_thing.type == "node" then
        local node = minetest.get_node_or_nil(pointed_thing.under)
        local def = node and minetest.registered_nodes[node.name]

        if not user:get_player_control().sneak and def and def.on_rightclick then
            return def.on_rightclick(pointed_thing.under, node, user, itemstack)
        end

        if def and def.buildable_to then pos = pointed_thing.under
        else
            pos = pointed_thing.above
            local anode = minetest.get_node_or_nil(pos)
            if not minetest.registered_nodes[anode.name] or not minetest.registered_nodes[anode.name].buildable_to then
                return itemstack
            end
        end
    elseif pointed_thing.type == "object" then
        pos = pointed_thing.ref:get_pos()
    else return end

    minetest.set_node(pos, {name = liquid_source})
    return ItemStack("fl_bucket:bucket")
end

minetest.register_craftitem(":fl_bucket:bucket_water", {
    description = "bucket of water",
    inventory_image = "farlands_bucket_water.png",
    stack_max = 1,
    liquids_pointable = true,
    on_place = function(itemstack, user, pointed_thing)
        return bucket_on_place(itemstack, user, pointed_thing, "fl_liquids:water_source")
    end,
    on_secondary_use = function(itemstack, user, pointed_thing)
        return bucket_on_place(itemstack, user, pointed_thing, "fl_liquids:water_source")
    end,
    groups = {bucket = 1},
})

minetest.register_craftitem(":fl_bucket:bucket_river_water", {
    description = "bucket of river water",
    inventory_image = "farlands_bucket_river_water.png",
    stack_max = 1,
    liquids_pointable = true,
    on_place = function(itemstack, user, pointed_thing)
        return bucket_on_place(itemstack, user, pointed_thing, "fl_liquids:river_water_source")
    end,
    on_secondary_use = function(itemstack, user, pointed_thing)
        return bucket_on_place(itemstack, user, pointed_thing, "fl_liquids:river_water_source")
    end,
    groups = {bucket = 1},
})

minetest.register_craftitem(":fl_bucket:bucket_lava", {
    description = "bucket of lava",
    inventory_image = "farlands_bucket_lava.png",
    stack_max = 1,
    liquids_pointable = true,
    on_place = function(itemstack, user, pointed_thing)
        return bucket_on_place(itemstack, user, pointed_thing, "fl_liquids:lava_source")
    end,
    on_secondary_use = function(itemstack, user, pointed_thing)
        return bucket_on_place(itemstack, user, pointed_thing, "fl_liquids:lava_source")
    end,
    groups = {bucket = 1},
})