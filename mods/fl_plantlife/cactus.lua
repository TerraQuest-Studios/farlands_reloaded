minetest.register_node("fl_plantlife:cactus", {
    description = "cactus",
    paramtype = "light",
    drawtype = "nodebox",
    use_texture_alpha = "clip",
    node_box = {
        type = "fixed",
        fixed = {-7/16, -0.5, -7/16, 7/16, 0.5, 7/16}
    },
    tiles = {
        "[combine:16x16:0,-16=farlands_cactus.png",
        "[combine:16x16:0,-16=farlands_cactus.png",
        "[combine:16x16:0,0=farlands_cactus.png",
    },
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(600, 1200))
    end,
    on_timer = function(pos, elapsed)
        --minetest.chat_send_all("triggered")
        local above = minetest.get_node_or_nil({x=pos.x, y=pos.y-1, z=pos.z})
        if not above then return end
        if not minetest.registered_nodes[above.name] or minetest.registered_nodes[above.name].drawtype == "airlike" then
            return
        end
        local under = minetest.get_node_or_nil({x=pos.x, y=pos.y-1, z=pos.z})
        --minetest.chat_send_all(under.name)
        if not under then return end
        if under.name == "fl_stone:sand" then
            minetest.set_node({x=pos.x, y=pos.y+1, z=pos.z}, {name = "fl_plantlife:cactus"})
            minetest.get_node_timer(pos):start(math.random(600, 1200))
            return
        elseif under.name == "fl_plantlife:cactus" then
            --minetest.chat_send_all("triggered")
            local base = minetest.get_node_or_nil({x=pos.x, y=pos.y-2, z=pos.z})
            if not base then return end
            if base.name ~= "fl_stone:sand" then return end
            minetest.set_node({x=pos.x, y=pos.y+1, z=pos.z}, {name = "fl_plantlife:cactus"})
            minetest.get_node_timer(pos):start(math.random(600, 1200))
        end
        minetest.get_node_timer(pos):start(math.random(600, 1200))
    end,
    _dungeon_loot = {chance = 0.7, count = {1, 3}, types = {"desert"}},
    groups = {oddly_breakable_by_hand = 3}
})