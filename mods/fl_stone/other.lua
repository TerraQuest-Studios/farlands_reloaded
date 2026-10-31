core.register_node("fl_stone:bedrock", {
    description = "bedrock",
    tiles = {"farlands_bedrock.png"},
    is_ground_content = false,
    drop = "",
    on_blast = function() end,
    on_destruct = function() end,
    can_dig = function() return false end,
    diggable = false,
    groups = {unbreakable = 1, not_in_creative_inventory = 1},
})

core.register_alias("fl_terrain:bedrock", "fl_stone:bedrock")