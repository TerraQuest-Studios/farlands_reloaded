--this will allow other mods to see crafts, but not modify the actual data used
--do note that because of this method, crafts can be registered during game play,
--however will not show up in registered_crafts
local registered_anvil_crafts = {}
minetest.register_on_mods_loaded(function()
    fl_workshop.registered_anvil_crafts = table.copy(registered_anvil_crafts)
end)

--this could have more protections
function fl_workshop.register_anvil_craft(craft_table)
    assert(craft_table, "[fl_workshop:anvil] failure to provide craft table!")
    if type(craft_table) ~= "table" then error("[fl_workshop:anvil] value passed is not a table!") end
    assert(craft_table.output, "[fl_workshop:anvil] failure to provide craft output!")
    if type(craft_table.output) ~= "string" then error("[fl_workshop:anvil] output is not a string!") end
    assert(craft_table.recipe, "[fl_workshop:anvil] failure to provide craft recipe!")
    if type(craft_table.recipe) ~= "table" then error("[fl_workshop:anvil] recipe is not a table!") end

    table.insert(registered_anvil_crafts, craft_table)
end

--[[
--how to use it
fl_workshop.register_anvil_craft({
    output = string value of output itemstack,
    recipe = {string itemstack, string itemstack}
})

--example registration
fl_workshop.register_anvil_craft({
    recipe = {"fl_tools:gold_shovel", "fl_ores:diamond_ore"},
    output = "fl_tools:diamond_shovel"
})
--]]

--table containing players currently shown anvil formspec
viewing_anvil = {}

minetest.register_node("fl_workshop:anvil", {
    description = "anvil",
    paramtype = "light",
    paramtype2 = "facedir",
    drawtype = "mesh",
    mesh = "farlands_anvil.obj",
    visual_scale = 0.5,
    wield_scale = {x=0.5, y=0.5, z=0.5},
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.3, -0.5, -0.45, 0.3, -0.2, 0.45}, --base
            {-0.25, -0.2, -0.375, 0.25, 0, 0.375}, --middle
            {-0.3125, 0, -0.5, 0.3125, 0.5, 0.5}, --top
        }
    },
    collision_box  = {
        type = "fixed",
        fixed = {
            {-0.3, -0.5, -0.45, 0.3, -0.2, 0.45}, --base
            {-0.25, -0.2, -0.375, 0.25, 0, 0.375}, --middle
            {-0.3125, 0, -0.5, 0.3125, 0.5, 0.5}, --top
        }
    },
    tiles = {"farlands_anvil.png"},
    on_construct = function(pos)
        local inv = minetest.get_meta(pos):get_inventory()
        inv:set_size("input", 2)
        inv:set_size("output", 1)
    end,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)

        --vars for stuff
        local chName = "chest name"
        local iPos = pos.x .. "," .. pos.y .. "," .. pos.z
        local cInvSize = clicker:get_inventory():get_size("main")
        local rLength = (cInvSize-9)/3
        local slotSize
        local formSize
        if rLength == 12 then slotSize, formSize = 0.725, "10.4,9.475"
        elseif rLength == 11 then slotSize, formSize = 0.8, "10.4,9.7"
        elseif rLength == 10 then slotSize, formSize = 0.89, "10.4,9.97"
        else slotSize, formSize = 1, "10.4,10.3" end

        --header of formspec
        local formspec = {
            "formspec_version[4]",
            "size[" .. formSize .. "]",
            "no_prepend[]",
            "style_type[box;colors=#77777710,#77777710,#777,#777]",
            "style_type[list;size=1;spacing=0.1]",
            "listcolors[#0000;#ffffff20]",
            "bgcolor[black;neither]",
            "background9[0,0;" .. formSize .. ";i3_bg_full.png;false;10]",
        }

        --build anvil part
        local anvil_formspec = {
            "image[0.25,0.5;2,2;farlands_hammer.png]",
            "label[3.25,1;Name & Upgrade]",
            --start description input
            "box[3.25,1.5;4,0.5;#bababa25]",
            "style_type[field;border=false]",
            "field[3.3,1.5;3.3,0.5;description;;]",
            "field_close_on_enter[description;false]",
            "style_type[image_button;border=false]",
            "style_type[image_button:hovered;fgimg=i3_export.png^\\[brighten]",
            "image_button[6.75,1.55;0.35,0.35;i3_export.png;set_description;]",
            --start crafting section
            "box[1.7,3.2;1,1;]",
            "list[nodemeta:" .. iPos .. ";input;1.7,3.2;1,1;]",
            "image[3.3,3.3;0.8,0.8;i3_dash.png^\\(i3_dash.png\\^[transformR90)]",
            "box[4.7,3.2;1,1;]",
            "list[nodemeta:" .. iPos .. ";input;4.7,3.2;1,1;1]",
            "image[6.2,3.2;1,1;i3_arrow.png]",
            "box[7.7,3.2;1,1;]",
            "list[nodemeta:" .. iPos .. ";output;7.7,3.2;1,1;]",
        }

        table.insert(formspec, table.concat(anvil_formspec, ""))

        --build inventory part of formspec
        table.insert(formspec, "label[0.3,5.4;Inventory]")
        table.insert(formspec, "style_type[box;colors=#77777710,#77777710,#777,#777]")
        for i=0, 8 do
            table.insert(formspec, "box[" .. 0.3+i+(i*0.1) ..",5.7;1,1;]")
        end
        table.insert(formspec, "list[current_player;main;0.3,5.7;9,1;]")
        table.insert(formspec, "style_type[list;size=" .. slotSize .. ";spacing=0.1]")
        table.insert(formspec, "style_type[box;colors=#666]") -- change bottom 3 rows color
        for i=0, 2 do
            for j=0, rLength-1 do
                table.insert(formspec, "box[" .. 0.3+(j*0.1)+(j*slotSize) .."," .. 6.8+(i*0.1)+(i*slotSize) .. ";"
                .. slotSize .. "," .. slotSize .. ";]")
            end
            table.insert(formspec, "list[current_player;main;0.3," .. 6.8+(i*0.1)+(i*slotSize) .. ";"
            .. rLength .. ",1;" .. 9+(rLength*i) .. "]")
        end

        --enable shiftclicking?
        table.insert(formspec, "listring[nodemeta:" .. iPos .. ";input]")
        table.insert(formspec, "listring[current_player;main]")

        --show formspec
        local chest_formspec = table.concat(formspec, "")
        minetest.show_formspec(clicker:get_player_name(), "fl_workshop:anvil_formspec", chest_formspec)
        viewing_anvil[clicker:get_player_name()] = pos
    end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if listname == "output" then return 0 else return stack:get_count() end
    end,
    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        if to_list == "output" then return 0
        elseif from_list == "output" and to_list == "input" then
            local inv = minetest.get_meta(pos):get_inventory()
            if inv:get_stack(to_list, to_index):is_empty() then return count else return 0 end
        else return 0 end
    end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        local inv = minetest.get_meta(pos):get_inventory()
        if listname == "input" and inv:get_stack(listname, 1):get_name() == inv:get_stack(listname, 2):get_name() then
            if minetest.get_item_group(inv:get_stack(listname, index):get_name(), "tool")  ~= 0 then
                local out_stack = inv:get_stack(listname, 1)
                out_stack:set_wear(65535 - ((65535 - inv:get_stack(listname, 1):get_wear()) + (65535 - inv:get_stack(listname, 2):get_wear())))
                inv:set_stack("output", 1, out_stack)
                return
            end
        end
        if not inv:get_stack("input", 1):is_empty() and not inv:get_stack("input", 2):is_empty() then
            for _, craft_table in pairs(registered_anvil_crafts) do
                if inv:get_stack("input", 1):get_name() == craft_table.recipe[1] and inv:get_stack("input", 2):get_name() == craft_table.recipe[2] then
                    inv:set_stack("output", 1, ItemStack(craft_table.output))
                end
            end
        end
    end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        local inv = minetest.get_meta(pos):get_inventory()
        if listname == "input" then inv:set_stack("output", 1, ItemStack(""))
        elseif listname == "output" then
            local one = inv:get_stack("input", 1)
            local two = inv:get_stack("input", 2)
            one:take_item()
            two:take_item()
            inv:set_stack("input", 1, one)
            inv:set_stack("input", 2, two)
        end
    end,
    on_dig = function(pos, node, digger)
        local inv = minetest.get_inventory({type="node", pos=pos})
        for _, item in ipairs(inv:get_list("input")) do
            local posi = {
                x=pos.x + (math.random(-2,2)/5),
                y=pos.y + (math.random(0,2)/5),
                z=pos.z + (math.random(-2,2)/5),
            }
            minetest.add_item(posi, item)
        end
        minetest.node_dig(pos, node, digger)
    end,
    on_place = minetest.rotate_node,
    groups = {oddly_breakable_by_hand = 1},
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "fl_workshop:anvil_formspec" then return end
    if fields.quit == "true" then
        viewing_anvil[player:get_player_name()] = nil
        return
    end

    --minetest.chat_send_all(dump(fields))

    local anvil_inv = minetest.get_inventory({type = "node", pos = viewing_anvil[player:get_player_name()]})
    if fields.description and not anvil_inv:get_stack("output", 1):is_empty() and fields.description ~= "" then
        local stack = anvil_inv:get_stack("output", 1)
        stack:set_count(1)
        stack:get_meta():set_string("description", fields.description)
        anvil_inv:set_stack("output", 1, stack)
    elseif anvil_inv:get_stack("output", 1):is_empty() and not anvil_inv:get_stack("input", 1):is_empty() and fields.description ~= "" then
        local stack = anvil_inv:get_stack("input", 1)
        stack:set_count(1)
        --testing colorization
        --stack:get_meta():set_string("description", minetest.colorize("#000000", fields.description))
        stack:get_meta():set_string("description", fields.description)
        anvil_inv:set_stack("output", 1, stack)
    end
end)