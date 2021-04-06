minetest.register_node("fl_storage:wood_chest", {
    description = "wood chest",
    paramtype = "light",
    paramtype2 = "facedir",
    on_construct = function(pos)
        local inv = minetest.get_meta(pos):get_inventory()
        inv:set_size("main", 9*4)
    end,
    tiles = {
        "farlands_chest_top.png",
		"farlands_chest_top.png",
		"farlands_chest_side.png",
		"farlands_chest_side.png",
		"farlands_chest_side.png",
		"farlands_chest_front.png",
    },
    groups = {oddly_breakable_by_hand = 3},
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)

        --vars for stuff
        local chName = "chest name"
        local iPos = pos.x .. "," .. pos.y .. "," .. pos.z
        local cInvSize = clicker:get_inventory():get_size("main")
        local rLength = (cInvSize-9)/3
        local slotSize
        if rLength == 12 then slotSize = 0.725
        elseif rLength == 11 then slotSize = 0.8
        elseif rLength == 10 then slotSize = 0.89
        else slotSize = 1 end

        --header of formspec
        local formspec = {
            "formspec_version[4]",
            "size[10.2,11.1]",
            "no_prepend[]",
            "style_type[box;colors=#77777710,#77777710,#777,#777]",
            "style_type[list;size=1;spacing=0.1]",
            "listcolors[#0000;#ffffff20]",
            "bgcolor[black;neither]",
            "background9[0,0;10.2,11.1;i3_bg_full.png;false;10]",
        }

        --build chest inventory
        local chest_inv = {
            "label[0.2,0.7;" .. chName .. "]",
        }

        for i=0, 3 do
            for j=0, 8 do
                table.insert(chest_inv, "box[" .. 0.2+j+(j*0.1) .. "," .. i+1+(i*0.1) .. ";1,1;]")
            end
        end
        table.insert(chest_inv, "list[nodemeta:" .. iPos .. ";main;0.2,1;9,4;]")
        table.insert(formspec, table.concat(chest_inv, ""))


        --build inventory part of formspec
        table.insert(formspec, "label[0.2,6.3;Inventory]")
        table.insert(formspec, "style_type[box;colors=#77777710,#77777710,#777,#777]")
        for i=0, 8 do
            table.insert(formspec, "box[" .. 0.2+i+(i*0.1) ..",6.6;1,1;]")
        end
        table.insert(formspec, "list[current_player;main;0.2,6.6;9,1;]")
        table.insert(formspec, "style_type[list;size=" .. slotSize .. ";spacing=0.1]")
        for i=0, 2 do
            for j=0, rLength-1 do
                table.insert(formspec, "box[" .. 0.2+(j*0.1)+(j*slotSize) .."," .. 7.7+(i*0.1)+(i*slotSize) .. ";"
                .. slotSize .. "," .. slotSize .. ";]")
            end
            table.insert(formspec, "list[current_player;main;0.2," .. 7.7+(i*0.1)+(i*slotSize) .. ";"
            .. rLength .. ",1;" .. 9+(rLength*i) .. "]")
        end

        --enable shiftclicking?
        table.insert(formspec, "listring[nodemeta:" .. iPos .. ";main]")
        table.insert(formspec, "listring[current_player;main]")

        --show formspec
        local chest_formspec = table.concat(formspec, "")
        minetest.show_formspec(clicker:get_player_name(), "fl_wildlife:trader_formspec", chest_formspec)
    end,
    on_dig = function(pos, node, digger)
        local inv = minetest.get_inventory({type="node", pos=pos})
        for _, item in ipairs(inv:get_list("main")) do
            local posi = {
                x=pos.x + (math.random(-2,2)/5),
                y=pos.y + (math.random(0,2)/5),
                z=pos.z + (math.random(-2,2)/5),
            }
            minetest.add_item(posi, item)
        end
        minetest.node_dig(pos, node, digger)
    end,
})
--bottom 3 rows of chest inv shouldnt be gradiented, needs to be fixed