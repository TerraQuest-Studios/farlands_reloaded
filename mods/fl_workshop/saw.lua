--table containing players currently shown saw formspec
viewing_saw = {}

--for some reason saw requires double click
local function updateformspec(pos, clicker)

    --vars for stuff
    local chName = "saw"
    local iPos = pos.x .. "," .. pos.y .. "," .. pos.z
    local cInvSize = clicker:get_inventory():get_size("main")
    local rLength = (cInvSize-9)/3
    local slotSize
    local formSize
    if rLength == 12 then slotSize, formSize = 0.725, "10.4,7.475"
    elseif rLength == 11 then slotSize, formSize = 0.8, "10.4,7.7"
    elseif rLength == 10 then slotSize, formSize = 0.89, "10.4,7.97"
    else slotSize, formSize = 1, "10.4,8.3" end

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
        "label[0.3,0.4;" .. chName .. "]",
        "box[1,1.2;1,1;]",
        "list[nodemeta:" .. iPos .. ";main;1,1.2;1,1;]",
        --"style_type[image_button,item_image_button;border=false]",
        "image[2.5,1.2;1,1;i3_arrow.png]",
    }

    for i=0, 1 do
        for j=0, 3 do
            table.insert(formspec, "image[" .. 4+j+(j*0.1) .. "," .. 0.6+i+(i*0.1) .. ";1,1;i3_slot.png]")
        end
    end

    local inv = minetest.get_inventory({type = "node", pos = pos})
    if not inv:is_empty("main") and inv:get_stack("main", 1):get_count() >= 6 then
        local stack = inv:get_stack("main", 1)
        --minetest.chat_send_all(stack:get_name())
        local node_table = {}
        if minetest.get_item_group(stack:get_name(), "stairable") ~= 0 then
            table.insert(node_table, {stack:get_name(), "slab", 4})
            table.insert(node_table, {stack:get_name(), "stair", 2})
            table.insert(node_table, {stack:get_name(), "outer_stair", 3})
            table.insert(node_table, {stack:get_name(), "inner_stair", 1})
        end
        if minetest.get_item_group(stack:get_name(), "fenceable") ~= 0 then
            table.insert(node_table, {stack:get_name(), "fence", 4})
        end
        if minetest.get_item_group(stack:get_name(), "wallable") ~= 0 then
            table.insert(node_table, {stack:get_name(), "wall", 2})
        end
        if minetest.get_item_group(stack:get_name(), "stone") ~= 0 then
            table.insert(node_table, {stack:get_name(), "block", 1})
        end
        table.insert(formspec, "style_type[item_image_button;border=false]")
        table.insert(formspec, "style_type[item_image_button;bgimg_hovered=i3_slot.png]")
        local x = 0
        local y = 0
        for i = 1, #node_table do
            if x==4 then x=0 y=1 end
            local nm = ItemStack(node_table[i][1] .. "_" .. node_table[i][2])
            nm:set_count(node_table[i][3])
            nm = nm:to_string()
            table.insert(
                formspec,
                "item_image_button[" .. 4+x+(x*0.1) .. "," .. 0.6+y+(y*0.1) .. ";1,1;"
                .. nm .. ";"
                .. node_table[i][2] .. ";]"
            )
            x=x+1
        end
    end

    --build inventory part of formspec
    table.insert(formspec, "label[0.3,3.4;Inventory]")--5.4
    table.insert(formspec, "style_type[box;colors=#77777710,#77777710,#777,#777]")
    for i=0, 8 do
        table.insert(formspec, "box[" .. 0.3+i+(i*0.1) ..",3.7;1,1;]")
    end
    table.insert(formspec, "list[current_player;main;0.3,3.7;9,1;]")
    table.insert(formspec, "style_type[list;size=" .. slotSize .. ";spacing=0.1]")
    table.insert(formspec, "style_type[box;colors=#666]") -- change bottom 3 rows color
    for i=0, 2 do
        for j=0, rLength-1 do
            table.insert(formspec, "box[" .. 0.3+(j*0.1)+(j*slotSize) .."," .. 4.8+(i*0.1)+(i*slotSize) .. ";"
            .. slotSize .. "," .. slotSize .. ";]")
        end
        table.insert(formspec, "list[current_player;main;0.3," .. 4.8+(i*0.1)+(i*slotSize) .. ";"
        .. rLength .. ",1;" .. 9+(rLength*i) .. "]")
    end

    --enable shiftclicking?
    table.insert(formspec, "listring[nodemeta:" .. iPos .. ";main]")
    table.insert(formspec, "listring[current_player;main]")

    --show formspec
    local saw_formspec = table.concat(formspec, "")
    --this breaks recieving fields
    minetest.show_formspec(clicker:get_player_name(), "fl_tool_nodes:saw_formspec", saw_formspec)
    viewing_saw[clicker:get_player_name()] = pos

    --local meta = minetest.get_meta(pos)
    --meta:set_string("formspec", saw_formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "fl_tool_nodes:saw_formspec" then return end
    if fields.quit == "true" then
        viewing_saw[player:get_player_name()] = nil
        return
    end

    local function add_item(item, gcount, tcount)
        local inv = player:get_inventory()
        local saw_inv = minetest.get_inventory({type = "node", pos = viewing_saw[player:get_player_name()]})
        local saw_stack = saw_inv:get_stack("main", 1)
        local stack = ItemStack(saw_stack:get_name() .. item)
        stack:set_count(gcount)
        if inv:room_for_item("main", stack) then
            inv:add_item("main", stack)
            saw_stack:take_item(tcount)
            saw_inv:set_stack("main", 1, saw_stack)
            for sname, spos in pairs(viewing_saw) do
                if vector.equals(spos, viewing_saw[player:get_player_name()]) then
                    updateformspec(spos, minetest.get_player_by_name(sname))
                end
            end
        end
    end
    if fields.inner_stair then add_item("_inner_stair", 1, 1)
    elseif fields.outer_stair then add_item("_outer_stair", 3, 1)
    elseif fields.stair then add_item("_stair", 2, 1)
    elseif fields.slab then add_item("_slab", 4, 1)
    elseif fields.block then add_item("_block", 1, 6)
    elseif fields.fence then add_item("_fence", 4, 1)
    elseif fields.wall then add_item("_wall", 2, 1)
    end
end)

--textures and nodebox are temperary and suck
minetest.register_node(":fl_stairs:tablesaw", {
    description = "table saw",
    tiles = {
        "farlands_apple_planks.png^farlands_saw_top.png",
        "farlands_apple_planks.png^farlands_saw_bottom.png",
        "farlands_apple_planks.png^farlands_saw_side.png"
    },
    groups = {oddly_breakable_by_hand = 3},
    drawtype = "nodebox",
    paramtype = "light",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.125, 0.5},--base
            {-0.01, -0.125, -0.3125, 0.01, 0.25, 0.3125},
            {-0.01, 0.25, -0.25, 0.01, 0.3125, 0.25},
            {-0.01, 0.3125, -0.1875, 0.01, 0.375, 0.1875},
            --{-0.01, 0.375, -0.125, 0.01, 0.4375, 0.125},
            {-0.01, 0.375, -0.0625, 0.01, 0.4375, 0.0625}
            --{-0.01, 0.4375, -0.0625, 0.01, 0.5, 0.0625} --top
        }
    },
    on_construct = function(pos)
        local inv = minetest.get_meta(pos):get_inventory()
        inv:set_size("main", 1)
    end,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        updateformspec(pos, clicker)
    end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        local get_group = minetest.get_item_group
        if get_group(stack:get_name(), "stairable") ~= 0
        or get_group(stack:get_name(), "fenceable") ~= 0
        or get_group(stack:get_name(), "wallable") ~= 0 then
            return stack:get_count()
        end
        return 0
    end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        for sname, spos in pairs(viewing_saw) do
            --if minetest.hash_node_position(spos) == minetest.hash_node_position(pos) then
            if vector.equals(spos, pos) then
                updateformspec(pos, minetest.get_player_by_name(sname))
            end
        end
    end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        for sname, spos in pairs(viewing_saw) do
            --if minetest.hash_node_position(spos) == minetest.hash_node_position(pos) then
            if vector.equals(spos, pos) then
                updateformspec(pos, minetest.get_player_by_name(sname))
            end
        end
    end,
    on_dig = function(pos, node, digger)
        local inv = minetest.get_inventory({type="node", pos=pos})
        for _, item in ipairs(inv:get_list("main")) do
            minetest.add_item(pos, item)
        end
        minetest.node_dig(pos, node, digger)
    end,
    on_place = function(itemstack, placer, pointed_thing)
        if itemstack:get_meta():get_string("description") == "wsaw"
        and pointed_thing.type == "node"
        and minetest.get_modpath("fl_tnt") then
            fl_tnt.boom(pointed_thing.under, {radius = 3})
            itemstack:take_item()
            --placer:set_wielded_item(itemstack)
            return itemstack
        end
        minetest.item_place(itemstack, placer, pointed_thing)
    end
})