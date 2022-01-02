--this file is far, far from perfect but is a effort to get a working furnace out currently
--todo: show fire animation and progress in formspec

--viewing_furnace = {}

local function _machine_input(pos, node, itemstack)
    local inv = minetest.get_meta(pos):get_inventory()
    if minetest.get_item_group(itemstack:get_name(), "fuel") >= 1 then
        return inv:add_item("fuel", itemstack)
    else
        local output, _ = minetest.get_craft_result({method = "cooking", width = 1, items = {itemstack}})
        if output.time == 0 or output.item:is_empty() then return itemstack end
        return inv:add_item("input", itemstack)
    end
end

local function on_rightclick(pos, node, clicker, itemstack, pointed_thing)

    --vars for stuff
    local chName = "furnace"
    local iPos = pos.x .. "," .. pos.y .. "," .. pos.z
    local cInvSize = clicker:get_inventory():get_size("main")
    local rLength = (cInvSize-9)/3
    local slotSize
    local formSize
    if rLength == 12 then slotSize, formSize = 0.725, "10.4,9.475"
    elseif rLength == 11 then slotSize, formSize = 0.8, "10.4,9.7"
    elseif rLength == 10 then slotSize, formSize = 0.89, "10.4,9.97"
    else slotSize, formSize = 1, "10.4,10.3" end

    if minetest.get_meta(pos):get_string("description") ~= "" then
        chName = minetest.get_meta(pos):get_string("description")
        --minetest.get_meta(pos):set_string("infotext", minetest.get_meta(pos):get_string("description"))
    end

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

    --build chest inventory
    local furnace_layout = {
        "label[0.3,0.4;" .. chName .. "]",
        "box[2.7,0.7;1,1;]",
        "list[nodemeta:" .. iPos .. ";input;2.7,0.7;1,1;]",
        "image[2.7,2.2;1,1;farlands_furnace_fire_bg.png]",
        "box[2.7,3.7;1,1;]",
        "list[nodemeta:" .. iPos .. ";fuel;2.7,3.7;1,1;]",
        "image[4.7,2.2;1,1;i3_arrow.png]",
        "box[6.7,2.2;1,1;]",
        "list[nodemeta:" .. iPos .. ";output;6.7,2.2;1,1;]",
    }
    table.insert(formspec, table.concat(furnace_layout, ""))


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
    table.insert(formspec, "listring[nodemeta:" .. iPos .. ";main]")
    table.insert(formspec, "listring[current_player;main]")

    --show formspec
    local chest_formspec = table.concat(formspec, "")
    --[[
    if viewing_furnace[minetest.hash_node_position(pos)] then
        local vft = viewing_furnace[minetest.hash_node_position(pos)]
        table.insert(vft, clicker:get_player_name())
        viewing_furnace[minetest.hash_node_position(pos)] = vft
    else viewing_furnace[minetest.hash_node_position(pos)] = {clicker:get_player_name()} end
    viewing_furnace[clicker:get_player_name()] = pos
    --]]
    minetest.show_formspec(clicker:get_player_name(), "fl_workshop:furnace_formspec", chest_formspec)
end

local function swap_node(pos, node)
    if minetest.get_node(pos).name == node.name then return end
    minetest.swap_node(pos, node)
end

local function on_timer(pos, elapsed)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    local ifuel, iinput, ioutput = inv:get_list("fuel"), inv:get_list("input"), inv:get_list("output")
    local total_time = meta:get_float("total_time") or 0
    total_time = total_time + elapsed
    local burn_time = meta:get_float("burn_time") or 0
    burn_time = burn_time - elapsed
    local coutput, _ = minetest.get_craft_result({method = "cooking", width = 1, items = iinput})

    if coutput.item:is_empty() or coutput.time == 0 then
        return swap_node(pos, {name = "fl_workshop:furnace", param2 = minetest.get_node(pos).param2})
    end

    if burn_time <= 0 and not ifuel[1]:is_empty() then
        local foutput, _ = minetest.get_craft_result({method = "fuel", width = 1, items = ifuel})
        if foutput.time == 0 then
            meta:set_float("burn_time", 0)
            return swap_node(pos, {name = "fl_workshop:furnace", param2 = minetest.get_node(pos).param2})
        end
        burn_time = foutput.time
        meta:set_float("burn_time", burn_time)
        ifuel[1]:take_item()
        inv:set_list("fuel", ifuel)
        --minetest.chat_send_all("fuel")
    elseif burn_time <= 0 then
        meta:set_float("burn_time", 0)
        return swap_node(pos, {name = "fl_workshop:furnace", param2 = minetest.get_node(pos).param2})
    else
        meta:set_float("burn_time", burn_time)
    end

    if coutput.time > total_time then
        minetest.get_node_timer(pos):start(1.0)
        meta:set_float("total_time", total_time)
        --minetest.chat_send_all("trigger1")
        return swap_node(pos, {name = "fl_workshop:furnace_active", param2 = minetest.get_node(pos).param2})
    else
        meta:set_float("total_time", 0)
        if iinput[1]:is_empty() then
            return swap_node(pos, {name = "fl_workshop:furnace", param2 = minetest.get_node(pos).param2})
        end
        if not ioutput[1]:is_empty() and coutput.item:get_name() ~= ioutput[1]:get_name() then
            return swap_node(pos, {name = "fl_workshop:furnace", param2 = minetest.get_node(pos).param2})
        end
        local remainder = inv:add_item("output", coutput.item)
        if remainder:is_empty() then iinput[1]:take_item() end
        inv:set_list("input", iinput)

        if not iinput[1]:is_empty() then minetest.get_node_timer(pos):start(1.0) end
        --minetest.chat_send_all("trigger2")
        return swap_node(pos, {name = "fl_workshop:furnace_active", param2 = minetest.get_node(pos).param2})
    end
end

minetest.register_node("fl_workshop:furnace", {
    description = "furnace",
    paramtype2 = "facedir",
    on_construct = function(pos)
        local inv = minetest.get_meta(pos):get_inventory()
        inv:set_size("input", 1)
        inv:set_size("fuel", 1)
        inv:set_size("output", 1)
    end,
    tiles = {
        "farlands_stone_block.png",
        "farlands_stone_block.png",
        "farlands_stone_block.png",
        "farlands_stone_block.png",
        "farlands_stone_block.png",
        "farlands_furnace_front.png",
    },
    groups = {oddly_breakable_by_hand = 3},
    on_rightclick = on_rightclick,
    on_metadata_inventory_put = function(pos) minetest.get_node_timer(pos):start(1.0) end,
    on_metadata_inventory_take = function(pos) minetest.get_node_timer(pos):start(1.0) end,
    on_metadata_inventory_move = function(pos) minetest.get_node_timer(pos):start(1.0) end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if listname == "output" then
            return 0
        elseif listname == "fuel" and minetest.get_item_group(stack:get_name(), "fuel") <= 0 then
            return 0
        end
        return stack:get_count()
    end,
    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        local stack = minetest.get_meta(pos):get_inventory():get_stack(from_list, from_index)
        if to_list == "output" then
            return 0
        elseif to_list == "fuel" and minetest.get_item_group(stack:get_name(), "fuel") <= 0 then
            return 0
        end
        return count
    end,
    on_timer = on_timer,
    _machine_input = _machine_input,
})

minetest.register_node("fl_workshop:furnace_active", {
    description = "furnace",
    paramtype2 = "facedir",
    on_construct = function(pos)
        local inv = minetest.get_meta(pos):get_inventory()
        inv:set_size("input", 1)
        inv:set_size("fuel", 1)
        inv:set_size("output", 1)
    end,
    tiles = {
        "farlands_stone_block.png",
        "farlands_stone_block.png",
        "farlands_stone_block.png",
        "farlands_stone_block.png",
        "farlands_stone_block.png",
        {
            image = "farlands_furnace_active.png",
            backface_culling = false,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 1.5
            },
        }
    },
    groups = {oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
    on_rightclick = on_rightclick,
    on_metadata_inventory_put = function(pos) minetest.get_node_timer(pos):start(1.0) end,
    on_metadata_inventory_take = function(pos) minetest.get_node_timer(pos):start(1.0) end,
    on_metadata_inventory_move = function(pos) minetest.get_node_timer(pos):start(1.0) end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if listname == "output" then
            return 0
        elseif listname == "fuel" and minetest.get_item_group(stack:get_name(), "fuel") <= 0 then
            return 0
        end
        return stack:get_count()
    end,
    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        local stack = minetest.get_meta(pos):get_inventory():get_stack(from_list, from_index)
        if to_list == "output" then
            return 0
        elseif to_list == "fuel" and minetest.get_item_group(stack:get_name(), "fuel") <= 0 then
            return 0
        end
        return count
    end,
    on_timer = on_timer,
    _machine_input = _machine_input,
})

--minetest.register_on_player_receive_fields(function(player, formname, fields)
    --[[
    if formname ~= "fl_workshop:furnace_formspec" and formname ~= "fl_workshop:furnace_active_formspec" then return end
    if fields.quit == "true" then
        local ref = viewing_furnace[minetest.hash_node_position(viewing_furnace[player:get_player_name()])]
        for i, name in pairs(ref) do
            if name == player:get_player_name() then
                table.remove(ref, i)
                if #ref == 0 then
                    --minetest.chat_send_all("test")
                    viewing_furnace[minetest.hash_node_position(viewing_furnace[player:get_player_name()])] = nil
                end
            end
        end
        viewing_furnace[player:get_player_name()] = nil
        return
    end
    --]]
--end)

minetest.register_craft({
    output = "fl_workshop:furnace",
    recipe = {
        {"group:stone", "group:stone", "group:stone"},
        {"group:stone", "", "group:stone"},
        {"group:stone", "group:stone", "group:stone"},
    },
})