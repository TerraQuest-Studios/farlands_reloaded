local function reg_grass(name)
    local desc = string.split(name, "_")
    local groups = {oddly_breakable_by_hand = 3, plant = 1, not_in_creative_inventory = 1}
    for i=1, 5 do
        minetest.register_node("fl_plantlife:" .. name .. "_" .. i, {
            description = table.concat(desc, " "),
            drawtype = "plantlike",
            paramtype = "light",
            paramtype2 = "degrotate",
            tiles = {"[combine:16x16:0," .. 10 - 2*i .. "=farlands_" .. name .. "_plant.png"},
            floodable = true,
            on_flood = function(pos, oldnode, newnode)
                minetest.dig_node(pos)
            end,
            selection_box = {
                type = "fixed",
                fixed = {-0.5,-0.5,-0.5,0.5,-0.45,0.5},
            },
            walkable = false,
            frop = "fl_plantlife:" .. name .. "_5",
            groups = groups,
        })
    end
    minetest.override_item("fl_plantlife:" .. name .. "_5", {
        inventory_image = "[combine:16x16:0,4=farlands_" .. name .. "_plant.png",
        groups = {oddly_breakable_by_hand = 3, plant = 1, not_in_creative_inventory = 0}
    })
end

reg_grass("grass")
reg_grass("savannah_grass")