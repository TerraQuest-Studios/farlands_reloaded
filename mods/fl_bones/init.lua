core.register_craftitem("fl_bones:bonemeal", {
    description = "bonemeal",
    inventory_image = "farlands_bonemeal.png",
    _dungeon_loot = {chance = 0.1, count = {4, 8}},
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then return end
        local node = core.get_node_or_nil(pointed_thing.under)
        if not node then return end
        if core.get_item_group(node.name, "plant") ~= 1 then return end

        local node_def = core.registered_nodes[node.name]
        if node_def._on_bonemeal then
            node_def._on_bonemeal(pointed_thing.under, user)
            itemstack:take_item()
            return itemstack
        end
        if core.get_node_timer(pointed_thing.under):is_started() then
            if math.random(10) > 8 then
                core.get_node_timer(pointed_thing.under):stop()
                node_def.on_timer(pointed_thing.under, 0)
            end
            itemstack:take_item()
            return itemstack
        end
        return
    end
})

core.register_craftitem("fl_bones:bone", {
    description = "bone",
    inventory_image = "farlands_bone.png",
    _dungeon_loot = {chance = 0.2, count = {2, 6}},
})

core.register_node("fl_bones:bone_block", {
    description = "bone block",
    tiles = {
        "farlands_bone_block_top.png",
        "farlands_bone_block_top.png",
        "farlands_bone_block.png"
    },
    groups = {dig_stone = 3},
})

--crafts
core.register_craft({
    output = "fl_bones:bone_block",
    type = "shapeless",
    recipe = {"fl_bones:bone", "fl_bones:bone", "fl_bones:bone"},
})

core.register_craft({
    output = "fl_bones:bonemeal 3",
    type = "shapeless",
    recipe = {"fl_bones:bone"},
})

core.register_craft({
    output = "fl_bones:bonemeal 9",
    type = "shapeless",
    recipe = {"fl_bones:bone_block"},
})