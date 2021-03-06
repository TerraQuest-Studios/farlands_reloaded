local fl_beds = {}
fl_beds.data = {}
fl_beds.active_beds = {}

for counter, dye in pairs(fl_dyes.dyes) do
    local cwool = "farlands_wool.png\\^[multiply\\:" .. fl_dyes.dyes[counter][3]
    minetest.register_node("fl_beds:bed_" .. fl_dyes.dyes[counter][1], {
        description = fl_dyes.dyes[counter][2] .. " bed",
        inventory_image = "farlands_beds_" .. fl_dyes.dyes[counter][1] .. ".png",
        wield_image = "farlands_beds_" .. fl_dyes.dyes[counter][1] .. ".png",
        paramtype = "light",
        paramtype2 = "facedir",
        use_texture_alpha = "clip",
        drawtype = "mesh",
        mesh = "farlands_bed.obj",
        selection_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 0.0625, 1.5}},
        collision_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 0.0625, 1.5}},
        tiles = {
            "[combine:41x41:" ..
            "30,9=(farlands_apple_planks.png^[transformR90):37,9=" .. cwool .. ":" .. --foot side
            "30,25=(farlands_apple_planks.png^[transformR90):37,25=(farlands_bed_top.png^[transformR90):" .. --head side
            "0,0=" .. cwool .. ":16,0=" .. cwool .. ":24,0=farlands_bed_top.png:" .. --upper side
            "0,4=farlands_apple_planks.png:16,4=farlands_apple_planks.png:" .. --lower side
            "0,9=" .. cwool .. ":0,25=" .. cwool .. ":0,9=farlands_bed_top.png:" .. --top
            "16,9=farlands_apple_planks.png:16,25=farlands_apple_planks.png" --bottom
        },
        after_place_node = function(pos, placer, itemstack)
            local base = minetest.get_node_or_nil(pos)
            if not base or not base.param2 then minetest.remove_node(pos) return true end
            local dir = minetest.facedir_to_dir(base.param2)
            local head_pos = {x=pos.x+dir.x,y=pos.y,z=pos.z+dir.z}
            local head = minetest.get_node_or_nil(head_pos)
            local def = minetest.registered_items[head.name] or nil
            if not head or not def or not def.buildable_to then
                minetest.remove_node(pos)
                minetest.chat_send_player(placer:get_player_name(), "[fl_beds]: No room to place the bed!")
                return true
            end
            minetest.set_node(pos, {name = base.name, param2 = base.param2})
            return false
        end,
        -- non complete bed sleep function that needs to be completed
        on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
            local cname = clicker:get_player_name()
            local dir = minetest.facedir_to_dir(minetest.get_node(pos).param2)
            local mpos = {x = pos.x + dir.x/2, y = pos.y+.07, z = pos.z+dir.z/2}
            local pos_hash = minetest.hash_node_position(pos)
            local time = minetest.get_timeofday()

            if fl_beds.data[cname] then return end

            if fl_beds.active_beds[pos_hash] and not fl_beds.data[cname] then
                minetest.chat_send_player(cname, "[fl_beds]: bed already in use")
                return
            elseif time > 0.2 and time < 0.805 then
                minetest.chat_send_player(cname, "[fl_beds]: its not night you fool")
                return
            end
            fl_beds.data[cname] = {}
            fl_beds.data[cname].spawn_pos = clicker:get_pos()
            fl_beds.data[cname].bed_hash = pos_hash
            clicker:set_pos(mpos)
            fl_beds.active_beds[pos_hash] = true
            fl_player.ignore[cname] = true
            clicker:set_animation(fl_player.animations["lay"], 0)
            fl_beds.data[clicker:get_player_name()].physics = clicker:get_physics_override()
            clicker:set_physics_override({speed = 0, jump = 0, gravity = 0})
            fl_beds.data[cname].eye_offset = clicker:get_eye_offset()
            clicker:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
            fl_beds.active = true

            minetest.after(5, function()
                if not fl_beds.active then return end
                minetest.set_timeofday(0.23)
                for name, pdata in pairs(fl_beds.data) do
                    local player = minetest.get_player_by_name(name)
                    player:set_pos(pdata.spawn_pos)
                    fl_player.ignore[name] = nil
                    player:set_physics_override({
                        speed = pdata.physics.speed,
                        jump = pdata.physics.jump,
                        gravity = pdata.physics.gravity,
                    })
                    clicker:set_eye_offset(pdata.eye_offset)

                    --clear stuff
                    fl_beds.active_beds[pdata.bed_hash] = nil
                    fl_beds.data[name] = nil
                    fl_beds.active = nil
                end
            end)
        end,
        --]]
        groups = {dig_generic = 4, bed = 1},
    })

    --note that this does not work properly in the engine, only exists for i3, see craft_hacks
    local wool = ItemStack(minetest.itemstring_with_palette("fl_wool:wool", counter - 1))
    wool:get_meta():set_string("description", fl_dyes.dyes[counter][2] .. " wool")
    minetest.register_craft({
        output = "fl_beds:bed_" .. fl_dyes.dyes[counter][1],
        recipe = {
            {wool:to_string(), wool:to_string(), wool:to_string()},
            {"group:plank", "group:plank", "group:plank"}
        },
    })

    minetest.register_craft({
        output = "fl_beds:bed_" .. fl_dyes.dyes[counter][1],
        type = "shapeless",
        recipe = {
            "group:bed",
            "fl_dyes:" .. dye[1] .. "_dye"
        },
    })
end

--i3 currently does not support showing this correctly
local function craft_hacks(itemstack, player, old_craft_grid, craft_inv)
    if string.sub(itemstack:get_name(), 1, 7) ~= "fl_beds" then return end
    local indexs = {}
    --for _, stack in pairs(craft_inv:get_list("craft")) do
    for _, stack in pairs(old_craft_grid) do
        --if stack ~= nil then
            if stack:get_name() == "fl_wool:wool" then
                local meta = stack:get_meta()
                table.insert(indexs,  meta:get_int("palette_index"))
            end
        --end
    end
    if indexs[1] == indexs[2] and indexs[2] == indexs[3] then
        return ItemStack("fl_beds:bed_" .. fl_dyes.dyes[indexs[1]+1][1])
    end
    return ItemStack()
end

minetest.register_craft_predict(craft_hacks)
minetest.register_on_craft(craft_hacks)

if minetest.get_modpath("i3") then
    local colors = {}
    for counter, dye in pairs(fl_dyes.dyes) do
        if dye[1] ~= "red" then table.insert(colors, dye[1]) end
    end

    i3.compress("fl_beds:bed_red", {
        replace = "red",
        by = colors
    })
end