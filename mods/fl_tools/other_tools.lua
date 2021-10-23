minetest.register_tool("fl_tools:shears", {
    description = "shears",
    inventory_image = "farlands_shears.png",
})

minetest.register_craftitem(":fl_bucket:bucket", {
    description = "bucket",
    inventory_image = "farlands_bucket.png",
    liquids_pointable = true,
    range = 5.2,
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type == "object" and pointed_thing.ref:get_luaentity().bucket then
            return pointed_thing.ref:get_luaentity().bucket(itemstack, user, pointed_thing.ref:get_luaentity())
        elseif pointed_thing.type == "object" then
            pointed_thing.ref:punch(user, 1.0, {full_punch_interval=1.0}, nil)
            return user:get_wielded_item()
        elseif pointed_thing.type == "node"
        and minetest.registered_items[minetest.get_node_or_nil(pointed_thing.under).name]._bucket then
            return minetest.registered_items[
                minetest.get_node_or_nil(pointed_thing.under).name]._bucket(itemstack, user, pointed_thing.under)
        end
    end,
    groups = {bucket = 1},
})

if minetest.get_modpath("fl_fire") then
    minetest.register_tool("fl_tools:flint_steel", {
        description = "flint and steel",
        inventory_image = "farlands_flint_steel.png",
        on_use = function(itemstack, user, pointed_thing)
            if pointed_thing.type ~= "node" then return end
            local node = minetest.get_node_or_nil(pointed_thing.under)
            if not node then return end
            local nodedef = minetest.registered_nodes[node.name]
            if not nodedef then return end
            if nodedef.on_ignite then
                nodedef.on_ignite(pointed_thing.under, user)
            elseif minetest.get_item_group(node.name, "flammable") >= 1 then
                minetest.set_node(pointed_thing.under, {name = "fl_fire:fire"})
            elseif nodedef.drawtype == "normal" then
                minetest.set_node(pointed_thing.above, {name = "fl_fire:fire"})

            end
        end,
    })
end