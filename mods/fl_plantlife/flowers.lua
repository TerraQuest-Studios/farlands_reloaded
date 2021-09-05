fl_plantlife.decoration_flowers = {}
local modpath = minetest.get_modpath("fl_plantlife")
local dir = minetest.get_dir_list(modpath .. "/textures", false)

for _, name in ipairs(dir) do
    if string.find(name, "ground") then
        local _, i = string.find(name, "farlands_flower_")
        local hold = string.sub(name, i+1, -1)
        local j, _ = string.find(hold, ".png")
        local fname = string.sub(hold, 1, j-1)
        local split = string.split(fname, "_")
        minetest.register_node("fl_plantlife:" .. fname, {
            description = table.concat(split, " "),
            drawtype = "nodebox",
            paramtype = "light",
            tiles = {name, name},
            inventory_image = name,
            wield_image = name,
            walkable = false,
            node_box = {
                type = "fixed",
                fixed = {-0.5, -0.48, -0.5, 0.5, -0.47, 0.5}
            },
            selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, -0.45, 0.5}
            },
            groups = {oddly_breakable_by_hand = 3, plant = 1, flower = 1}
        })
    elseif string.find(name, "farlands_flower") then
        local _, i = string.find(name, "farlands_flower_")
        local hold = string.sub(name, i+1, -1)
        local j, _ = string.find(hold, ".png")
        local fname = string.sub(hold, 1, j-1)
        local split = string.split(fname, "_")
        minetest.register_node("fl_plantlife:" .. fname, {
            description = table.concat(split, " "),
            drawtype = "plantlike",
            paramtype = "light",
            inventory_image = name,
            walkable = false,
            tiles = {name},
            selection_box = {
                type = "fixed",
                fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
            },
            groups = {oddly_breakable_by_hand = 3, plant = 1, flower = 1, potable = 1}
        })
        table.insert(fl_plantlife.decoration_flowers, "fl_plantlife:" .. fname)
    end
end

--foxglove_pink/purple
--flower to dyes need to be done