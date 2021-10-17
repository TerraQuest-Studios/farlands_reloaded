minetest.register_entity("fl_signs:text", {
    initial_properties = {
        visual = "upright_sprite",
        textures = {"[combine:16x16"},
        static_save = true,
        collisionbox = {-0.5, -0.5, -0.01, 0.5, 0.5, 0.01},
        selectionbox = {0,0,0,0,0,0},
    },
    get_staticdata = function(self)
        local tmp = {memory = self.memory}
        return minetest.serialize(tmp)
    end,
    on_activate = function(self, staticdata, dtime_s)
        local sdata = minetest.deserialize(staticdata)
        if sdata then
            for k,v in pairs(sdata) do
                self[k] = v
            end
        end
        if not self.memory then self.memory = {} end
        if self.memory.textures then self.object:set_properties({textures = {self.memory.textures}}) end
    end,
})

local NCalphabelt = "0123456789.:,;(*!?}^)#${%^&_+@"
local Ualphabelt = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
local Lalphabelt = string.lower(Ualphabelt)
local location = {}
location[" "] = "27,0"

for i = 1, #NCalphabelt do
    local c = NCalphabelt:sub(i,i)
    -- do something with c
    location[c] = i-1 .. ",2"
end

for i = 1, #Ualphabelt do
    local c = Ualphabelt:sub(i,i)
    -- do something with c
    location[c] = i-1 .. ",1"
end

for i = 1, #Lalphabelt do
    local c = Lalphabelt:sub(i,i)
    -- do something with c
    location[c] = i-1 .. ",0"
end

local function create_text_ent(pos, param, rot)
    local ent = minetest.add_entity(pos, "fl_signs:text")
    local texture = "[combine:256x256"
    local text_table = param:split(" ")
    local max_length = 23 --defined to limit words to sign, max: 256x256 28 --128x128 is 14
    local line_length = 3 --starting 4 chars in
    local line_number = 54 --start at line 4
    for _, word in pairs(text_table) do
        if #word+line_length > max_length and #word < max_length then
            line_number = line_number+18
            line_length = 3
        end
        if line_number >= 198 then break end--line_number = 260 end
        for i = 1, #word do
            local c = word:sub(i,i)
            local loc = location[c]
            if not loc then loc = location[" "] end
            texture = texture .. ":".. line_length*9 ..","..line_number.."=font_1.png\\^[sheet\\:28x3\\:" .. loc
            line_length = line_length+1
        end
        texture = texture .. ":".. line_length*9 ..","..line_number.."=font_1.png\\^[sheet\\:28x3\\:" .. location[" "]
        line_length = line_length+1
    end
    ent:set_properties({textures = {texture}})
    ent:get_luaentity().memory.textures = texture
    ent:set_yaw(rot)
end

local offsets = {
    [2] = {
        rot = 90*(math.pi/180),
        pos = vector.new(0.425,0,0),
    },
    [3] = {
        rot = 90*(math.pi/180),
        pos = vector.new(-0.425,0,0),
    },
    [4] = {
        rot = 0,
        pos = vector.new(0,0,0.425),
    },
    [5] = {
        rot = 0,
        pos = vector.new(0,0,-0.425),
    },
}

minetest.register_node("fl_signs:sign_wood", {
    description = "wood sign",
    inventory_image = "farlands_sign_wood_inv.png",
    wield_image = "farlands_sign_wood_inv.png",
    tiles = {"farlands_sign_wood.png"},
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "wallmounted",
    sunlight_propagates = true,
    node_box = {
        type = "wallmounted",
        wall_side = {-0.5, -0.3125, -0.4375, -0.4375, 0.3125, 0.4375},
        wall_top = {-0.5, -0.3125, -0.4375, -0.4375, 0.3125, 0.4375},
        wall_bottom = {-0.5, -0.3125, -0.4375, -0.4375, 0.3125, 0.4375},
    },
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        local text = minetest.get_meta(pos):get("text") or ""
        local formspec = {
            "formspec_version[4]",
            "size[10.4,5.25]",
            "no_prepend[]",
            "style_type[box;colors=#77777710,#77777710,#777,#777]",
            "style_type[list;size=1;spacing=0.1]",
            "listcolors[#0000;#ffffff20]",
            "bgcolor[black;neither]",
            "background9[0,0;10.4,5.25;i3_bg_full.png;false;10]",
            "textarea[0.5,0.5;9.4,3;" .. "Pos: " .. minetest.pos_to_string(pos, 2) .. ";;" .. text .. "]",
            "field_close_on_enter[test;false]",
            "button[4.2,4;2,0.75;enter;Write]",
        }
        minetest.show_formspec(clicker:get_player_name(), "fl_signs:sign_wood", table.concat(formspec, ""))
    end,
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then return itemstack end
        if pointed_thing.under.y+1 == pointed_thing.above.y then return itemstack end
        return minetest.item_place(itemstack, placer, pointed_thing)
    end,
    groups = {sign = 1, dig_generic = 4}
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "fl_signs:sign_wood" then return end
    --minetest.chat_send_all(dump(fields))
    local text = {}
    if fields.enter then
        for key, data in pairs(fields) do
            if key:find("Pos: ") then
                text = {key, data}
            end
        end
    end
    if fields.enter and text then
        local split = text[1]:split(" ")
        local pos = minetest.string_to_pos(split[2])
        local node = minetest.get_node_or_nil(pos)
        if not node then return end
        if not offsets[node.param2] then return end
        minetest.get_meta(pos):set_string("text", text[2])
        local ents = minetest.get_objects_inside_radius(pos, 0.5)

        for _, ent in pairs(ents) do
            local entn = ent:get_luaentity().name
            if entn == "fl_signs:text" then
                ent:remove()
            end
        end

        pos = vector.add(pos, offsets[node.param2].pos)
        create_text_ent(pos, text[2], offsets[node.param2].rot)
    end

    --minetest.chat_send_all(dump(minetest.get_position_from_hash()))
end)