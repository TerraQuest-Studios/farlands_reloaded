local modpath = minetest.get_modpath("fl_trees")

local function register_sapling(name, offset)
    minetest.register_node("fl_trees:" .. name .. "_sapling", {
        description = name .. " sapling",
        drawtype = "plantlike",
        paramtype = "light",
        sunlight_propagates = true,
        walkable = true,
        tiles = {"farlands_" .. name .. "_sapling.png"},
        groups = {oddly_breakable_by_hand = 3, plant = 1},
        on_timer = function(pos)
            minetest.remove_node(pos)
            minetest.place_schematic(
                {x=pos.x-offset.x, y=pos.y, z=pos.z-offset.y},
                modpath .. "/schems/" .. name .. "_tree_" .. math.random(5) .. ".mts",
                "random",
                nil,
                false
            )
        end,
        on_costruct = function(pos)
            minetest.remove_node(pos)
            minetest.get_node_timer(pos):start(20)
        end,
        on_place = function(itemstack, placer, pointed_thing)
            if pointed_thing.type ~= "node" then return end
            minetest.get_node_timer(pointed_thing.above):start(20)
            return minetest.item_place(itemstack, placer, pointed_thing)
        end,
        selection_box = {type = "fixed", fixed = {-0.2, -0.5, -0.2, 0.2, 0.5, 0.2}},
        collision_box = {type = "fixed", fixed = {-0.2, -0.5, -0.2, 0.2, 0.5, 0.2}}
    })
end

register_sapling("aspen", {x=2,y=2})
register_sapling("baobab", {x=3,y=3})
register_sapling("apple", {x=2,y=2})
register_sapling("acacia", {x=3,y=3})
register_sapling("palm", {x=3,y=3})
register_sapling("pine", {x=2,y=2})
register_sapling("jungletree", {x=3,y=3})