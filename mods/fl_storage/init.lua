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
        local formSize
        if rLength == 12 then slotSize, formSize = 0.725, "10.4,9.475"
        elseif rLength == 11 then slotSize, formSize = 0.8, "10.4,9.7"
        elseif rLength == 10 then slotSize, formSize = 0.89, "10.4,9.97"
        else slotSize, formSize = 1, "10.4,10.3" end

        if minetest.get_meta(pos):get_string("description") ~= "" then
            chName = minetest.get_meta(pos):get_string("description")
            minetest.get_meta(pos):set_string("infotext", minetest.get_meta(pos):get_string("description"))
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
        local chest_inv = {
            "label[0.3,0.4;" .. chName .. "]",
        }

        for i=0, 3 do
            for j=0, 8 do
                table.insert(chest_inv, "box[" .. 0.3+j+(j*0.1) .. "," .. i+0.7+(i*0.1) .. ";1,1;]")
            end
        end
        table.insert(chest_inv, "list[nodemeta:" .. iPos .. ";main;0.3,0.7;9,4;]")
        table.insert(formspec, table.concat(chest_inv, ""))


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
        minetest.show_formspec(clicker:get_player_name(), "fl_storage:chest_formspec", chest_formspec)
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
    preserve_metadata = function(pos, oldnode, oldmeta, drops)
        if minetest.get_meta(pos):get_string("description") ~= "" then
            drops[1]:get_meta():set_string("description", minetest.get_meta(pos):get_string("description"))
        end
    end,
})

local function shelf_nodes(name)
    local overlays = {"book", "empty", "multi", "vessel"}

    for _, overlay in pairs(overlays) do
        local group = table.copy(minetest.registered_nodes["fl_trees:" .. name .. "_plank"]["groups"])
        group[overlay .. "_shelf"] = 1
        group["plank"] = nil
        group["stairable"] = nil
        group["fenceable"] = nil

        minetest.register_node("fl_storage:" .. name .. "_" .. overlay .. "_shelf", {
            description = name .. " " .. overlay .. " shelf",
            tiles = {
                "farlands_" .. name .. "_planks.png",
                "farlands_" .. name .. "_planks.png",
                "farlands_" .. name .. "_planks.png^farlands_" .. overlay .. "_shelf_overlay.png",
            },
            paramtype2 = "facedir",
            place_param2 = 0,
            on_construct = function(pos)
                local inv = minetest.get_meta(pos):get_inventory()
                inv:set_size("main", 9*2)
            end,
            on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
                --vars
                local iPos = pos.x .. "," .. pos.y .. "," .. pos.z
                local cname = overlay .. " shelf"
                local cInvSize = clicker:get_inventory():get_size("main")
                local rLength = (cInvSize-9)/3
                local slotSize
                local formSize
                if rLength == 12 then slotSize, formSize = 0.725, "10.4,7.275"
                elseif rLength == 11 then slotSize, formSize = 0.8, "10.4,7.5"
                elseif rLength == 10 then slotSize, formSize = 0.89, "10.4,7.77"
                else slotSize, formSize = 1, "10.4,8.1" end

                if minetest.get_meta(pos):get_string("description") ~= "" then
                    cname = minetest.get_meta(pos):get_string("description")
                    minetest.get_meta(pos):set_string("infotext", minetest.get_meta(pos):get_string("description"))
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
                local chest_inv = {
                    "label[0.3,0.4;" .. cname .. "]",
                }

                for i=0, 1 do
                    for j=0, 8 do
                        table.insert(chest_inv, "box[" .. 0.3+j+(j*0.1) .. "," .. i+0.7+(i*0.1) .. ";1,1;]")
                        if overlay == "vessel" or overlay == "book" then
                            local img = "farlands_" .. overlay .. "_shelf_slot.png^[colorize:#ffffff:75"
                            table.insert(
                                chest_inv,
                                "image[" .. 0.3+j+(j*0.1) .. "," .. i+0.7+(i*0.1) .. ";1,1;" ..img .. "]"
                            )
                        end
                    end
                end
                table.insert(chest_inv, "list[nodemeta:" .. iPos .. ";main;0.3,0.7;9,2;]")
                table.insert(formspec, table.concat(chest_inv, ""))

                --build inventory part of formspec
                table.insert(formspec, "label[0.3,3.2;Inventory]")
                table.insert(formspec, "style_type[box;colors=#77777710,#77777710,#777,#777]")
                for i=0, 8 do
                    table.insert(formspec, "box[" .. 0.3+i+(i*0.1) ..",3.5;1,1;]")
                end
                table.insert(formspec, "list[current_player;main;0.3,3.5;9,1;]")
                table.insert(formspec, "style_type[list;size=" .. slotSize .. ";spacing=0.1]")
                table.insert(formspec, "style_type[box;colors=#666]") -- change bottom 3 rows color
                for i=0, 2 do
                    for j=0, rLength-1 do
                        table.insert(
                            formspec,
                            "box[" .. 0.3+(j*0.1)+(j*slotSize) .."," .. 4.6+(i*0.1)+(i*slotSize) .. ";"
                            .. slotSize .. "," .. slotSize .. ";]"
                        )
                    end
                    table.insert(formspec, "list[current_player;main;0.3," .. 4.6+(i*0.1)+(i*slotSize) .. ";"
                    .. rLength .. ",1;" .. 9+(rLength*i) .. "]")
                end

                --enable shiftclicking?
                table.insert(formspec, "listring[nodemeta:" .. iPos .. ";main]")
                table.insert(formspec, "listring[current_player;main]")

                local shelf_formspec = table.concat(formspec, "")
                minetest.show_formspec(clicker:get_player_name(), "fl_storage:shelf_formspec", shelf_formspec)
            end,
            allow_metadata_inventory_put = function(pos, listname, index, stack, player)
                if overlay == "vessel" or overlay == "book" then
                    if minetest.get_item_group(stack:get_name(), overlay) ~= 0 then
                        return stack:get_count()
                    end
                    return 0
                end
                return stack:get_count()
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
            preserve_metadata = function(pos, oldnode, oldmeta, drops)
                if minetest.get_meta(pos):get_string("description") ~= "" then
                    drops[1]:get_meta():set_string("description", minetest.get_meta(pos):get_string("description"))
                end
            end,
            on_place = minetest.rotate_node,
            groups = group,
        })
    end
end

shelf_nodes("acacia")
shelf_nodes("apple")
shelf_nodes("aspen")
shelf_nodes("pine")
shelf_nodes("spruce")
shelf_nodes("yellow_ipe")
shelf_nodes("willow")
shelf_nodes("baobab")