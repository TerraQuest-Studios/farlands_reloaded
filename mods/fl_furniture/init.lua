local furnitures = {
	chair = {
        { -0.3, -0.5, 0.2, -0.2, 0.5, 0.3 }, -- foot 1
        { 0.2, -0.5, 0.2, 0.3, 0.5, 0.3 }, -- foot 2
        { 0.2, -0.5, -0.3, 0.3, -0.1, -0.2 }, -- foot 3
        { -0.3, -0.5, -0.3, -0.2, -0.1, -0.2 }, -- foot 4
        { -0.3, -0.1, -0.3, 0.3, 0, 0.2 }, -- seating
        { -0.2, 0.1, 0.25, 0.2, 0.4, 0.26 } -- conector 1-2
	},
	table = {
        { -0.4, -0.5, -0.4, -0.3, 0.4, -0.3 }, -- foot 1
        { 0.3, -0.5, -0.4, 0.4, 0.4, -0.3 }, -- foot 2
        { -0.4, -0.5, 0.3, -0.3, 0.4, 0.4 }, -- foot 3
        { 0.3, -0.5, 0.3, 0.4, 0.4, 0.4 }, -- foot 4
        { -0.5, 0.4, -0.5, 0.5, 0.5, 0.5 } -- table top
	},
	bench = {
        { -0.5, -0.1, 0, 0.5, 0, 0.5 }, -- seating
        { -0.4, -0.5, 0, -0.3, -0.1, 0.5 }, -- foot 1
        { 0.3, -0.5, 0, 0.4, -0.1, 0.5 } -- foot 2
	}
}

for name, nodebox in pairs(furnitures) do
    for _, wood_type in pairs(fl_trees.types) do
        minetest.register_node("fl_furniture:" .. wood_type .. "_" .. name, {
            description = wood_type .. " " .. name,
            drawtype = "nodebox",
            paramtype = "light",
            paramtype2 = "facedir",
            tiles = {
                {
                    name = "farlands_" .. wood_type .. "_planks.png",
                    align_style = "world",
                }
            },
            node_box = {
                type = "fixed",
                fixed = nodebox
            },
            groups = {dig_tree = 1, oddly_breakable_by_hand = 2},
            sounds = fl_trees.sounds.wood()
        })
    end

    if minetest.get_modpath("i3") then
        local wood_types = table.copy(fl_trees.types)
        wood_types[#wood_types] = nil
            i3.compress("fl_furniture:apple_" .. name, {
                replace = "apple",
                by = wood_types
            })
    end
end