viewing_furnace = {}

local function update_active(pos, pname, firep, arrowp)

    --vars for stuff
    local clicker = minetest.get_player_by_name(pname)
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

    local car = "(i3_arrow.png^[transformR90)"
    local arrow_out = "(" .. car .. "^[lowpart:" .. arrowp .. ":(" .. car .. "^[brighten))^[transformR270"

    --build chest inventory
    local furnace_layout = {
        "label[0.3,0.4;" .. chName .. "]",
        "box[2.7,0.7;1,1;]",
        "list[nodemeta:" .. iPos .. ";input;2.7,0.7;1,1;]",
        "image[2.7,2.2;1,1;farlands_furnace_fire_bg.png^[lowpart:" .. firep ..":farlands_furnace_fire_fg.png]",
        "box[2.7,3.7;1,1;]",
        "list[nodemeta:" .. iPos .. ";fuel;2.7,3.7;1,1;]",
        "image[4.7,2.2;1,1;" .. arrow_out .. "]",
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
    minetest.show_formspec(clicker:get_player_name(), "fl_workshop:furnace_active_formspec", chest_formspec)
end

local function furnace_nt(pos, elapsed)
    --minetest.chat_send_all(elapsed)
    --return true
    --[[
    if viewing_furnace[minetest.hash_node_position(pos)] then
        for _, pname in pairs(viewing_furnace[minetest.hash_node_position(pos)]) do
            update_active(pos, pname, 40, 70)
        end
    end
    --]]

	return false
end

    --if either or empty, do nothing
    --if inv:is_empty("input") or inv:is_empty("fuel") then return false end

    --local Coutput, Creturn = minetest.get_craft_result({method = "cooking", width = 1, items = inv:get_list("input")})
    --local Foutput, Freturn = minetest.get_craft_result({method = "fuel", width = 1, items = inv:get_list("fuel")})

    --not valid fuel or cookable item, do nothing
    --if Coutput.time == 0 or Foutput.time == 0 then return false end

    --[[debug dumps
    minetest.chat_send_all(dump(Coutput))
    minetest.chat_send_all(dump(Creturn))
    minetest.chat_send_all("break")
    minetest.chat_send_all(dump(Foutput))
    minetest.chat_send_all(dump(Freturn))
    --]]

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
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)

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
        if viewing_furnace[minetest.hash_node_position(pos)] then
            local vft = viewing_furnace[minetest.hash_node_position(pos)]
            table.insert(vft, clicker:get_player_name())
            viewing_furnace[minetest.hash_node_position(pos)] = vft
        else viewing_furnace[minetest.hash_node_position(pos)] = {clicker:get_player_name()} end
        viewing_furnace[clicker:get_player_name()] = pos
        minetest.show_formspec(clicker:get_player_name(), "fl_workshop:furnace_formspec", chest_formspec)
    end,
    on_metadata_inventory_put = function(pos) minetest.get_node_timer(pos):start(1.0) end,
    on_metadata_inventory_take = function(pos) minetest.get_node_timer(pos):start(1.0) end,
    on_metadata_inventory_move = function(pos) minetest.get_node_timer(pos):start(1.0) end,
    on_timer = furnace_nt,
})

minetest.register_node("fl_workshop:furnace_active", {
    description = "furnace",
    paramtype2 = "facedir",
    --this will be used because furnace is swaped to furnace_active
    on_timer = furnace_nt,
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
    groups = {oddly_breakable_by_hand = 3},
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
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
end)