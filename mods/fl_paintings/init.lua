--todo implement painting mechanics
--currently not avaible for survival

--function from https://github.com/GreenXenith/entity_anim Greenxenith MIT
local function get_file_dimensions(path)
    local f = io.open(path, "rb")
    f:seek("set", 1)
    if f:read(3) == "PNG" then
        f:seek("set", 16)
        return {
            w = tonumber(string.format("0x%x%x%x%x", f:read(4):byte(1, 4))),
            h = tonumber(string.format("0x%x%x%x%x", f:read(4):byte(1, 4))),
        }
    end
end

local box_data = {
    s = {{-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5}, "farlands_1X1.obj"},
    m = {{-1.5, -0.5, 0.4375, 0.5, 0.5, 0.5}, "farlands_1X2.obj"},
    t = {{-0.5, -0.5, 0.4375, 0.5, 1.5, 0.5}, "farlands_2X1.obj"},
    l = {{-0.5, -0.5, 0.4375, 1.5, 1.5, 0.5}, "farlands_2X2.obj"},
}

for _, img in pairs(minetest.get_dir_list(minetest.get_modpath("fl_paintings").."/textures")) do
    local size = get_file_dimensions(minetest.get_modpath("fl_paintings").."/textures/"..img)
    local fn = string.split(img, ".")[1]
    local name = string.split(fn, "_")[3]
    local data
    if not size then break end
    --if size.w == 128 and size.h == 64 then
        --data = box_data.l
    if size.w == 64 and size.h == 64 then
        data = box_data.t
    elseif size.w == 128 and size.h == 64 then
        data = box_data.m
    elseif size.w == 64 and size.h == 32 then
        data = box_data.s
    end

    if img == "farlands_ptg_cthulhu.png" then data = box_data.l end

    minetest.register_node("fl_paintings:" .. name, {
        description = name .. " painting",
        drawtype = "mesh",
        mesh = data[2],
        tiles = {img},
        paramtype = "light",
        paramtype2 = "facedir",
        use_texture_alpha = "clip",
        visual_scale = 0.5,
        wield_scale = {x=0.25, y=0.25, z=0.25},
        selection_box = {
            type = "fixed",
            fixed = data[1],
        },
        collision_box = {
            type = "fixed",
            fixed = data[1],
        },
        _dungeon_loot = {chance = math.random(0, 0.3)},
        groups = {dig_generic = 3},
    })
end