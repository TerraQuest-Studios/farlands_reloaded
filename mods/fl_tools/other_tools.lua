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