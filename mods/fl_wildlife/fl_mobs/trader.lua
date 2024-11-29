local function villager_brain(self)
    if mobkit.timer(self,1) then fl_wildlife.node_dps_dmg(self) end --if in nodes with damage take damage
    mobkit.vitals(self)

    if self.hp <= 0 then --kill self if 0 hp
        local item_drops = fl_wildlife.drops(self.drops)
        if item_drops ~= nil then
            for _, i in pairs(item_drops) do
                minetest.add_item(mobkit.get_stand_pos(self), i)
            end
        end

        mobkit.clear_queue_high(self)
        fl_wildlife.hq_die(self)
        return
    end

    if mobkit.timer(self,1) then
        local prty = mobkit.get_queue_priority(self)

        if prty < 20 and self.isinliquid then
            mobkit.hq_liquid_recovery(self,20)
            return
        end

        if mobkit.is_queue_empty_high(self) then
            --mobkit.animate(self, "walk")
            mobkit.hq_roam(self,0)
            --fl_wildlife.hq_npc_roam(self, 0)
        end

    end

end

minetest.register_entity("fl_wildlife:trader", {
    physical = true,
    stepheight = 1.1,
    collide_with_objects = true,
    collisionbox = {-0.35, 0, -0.35, 0.35, 1.9, 0.35},
    visual = "mesh",
    mesh = "farlands_npc_trader.b3d",
    textures = {"farlands_npc_trader.png"},
    visual_size = {x = 0.9, y = 0.9, z = 0.9},
    static_save = true,

    on_step = mobkit.stepfunc,
    on_activate = fl_wildlife.actfunc,
    get_staticdata = mobkit.statfunc,

    --mobkit properties
    buoyancy = 0, --how it works in water
    max_speed = 2, --how fast it can go
    jump_height = 1.1, --jumping height? not sure how this is different from mte stepheight
    view_range = 24, --how far it can see
    lung_capacity = 10, --seconds till drowning
    max_hp = 20, --health, not sure how this measured? like player where 2hp = 1 heart?
    armor_groups = {fleshy = 100},
    timeout = 0, --how long inactive till there killed, 0 is never CHANGE THIS
    attack={range=0.5,damage_groups={fleshy=3}}, --how close youhave to be to attack?
    --no sounds atm
    animation = { --animations, no idea what these are
        speed = {range = {x=15,y=20}, speed = 1.3, loop = true},
        stand = {range = {x=1,y=30}, speed = 10, loop = true},
        walk = {range = {x=35,y=55}, speed = 10, loop = true},
        run = {range = {x=35,y=55}, speed = 50, loop = true},
        punch = {range = {x=35,y=55}, speed = 10, loop = true},
    },

    --custom to this mod
    drops = "fl_wildlife.trader.drops",

    brainfunc = villager_brain,--villager_brain, --function for the brain
    _egg_it = {"trader", "#3c521d"},

    --experiments
    on_rightclick = function(self, clicker)
        --fl_wildlife.rclick_name(self, clicker)

        --vars for stuff
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
            --"list[current_player;main;0,0;9,1;0",
            --"image[0,0;1,1;i3_btn9.png]",
            --"image[1.1,0;1,1;i3_slot.png]", --this is slot from item list
            --"box[0.22,6.6;1,1;]",
            --"list[current_player;main;0.22,6.6;9,1;]",
        }

        --build trade list
        local trade_list = {
            "label[1.9,0.5;Trades]",
            "box[0.2,1;3.81,5;]",
            "scrollbaroptions[arrows=hide;smallstep=3;thumbsize=200;max=1000]",
            "scrollbar[4,1;0.15,5;vertical;trade_list;0]",
            "scroll_container[0.2,1;3.81,5;trade_list;vertical;0.1]",
            --start button
            "image_button[0.1,0.2;3.6,0.75;i3_slot.png;trade1;;noclip=false;false;i3_slot.png^\\[brighten]]",
            "image[0.6,0.38;0.4,0.4;farlands_stone.png]",
            "label[0.85,0.8;32]",
            "image[1.65,0.36;0.5,0.5;i3_arrow.png]",
            "image[2.8,0.38;0.4,0.4;farlands_desert_stone.png]",
            --end button
            "scroll_container_end[]",
            --trade items mock up
            "box[5,3;1,1;]",
            "image[6.5,3;1,1;i3_arrow.png]",
            "box[8,3;1,1;]",
        }
        table.insert(formspec, table.concat(trade_list, ""))

        --build inventory part of formspec
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

        --show formspec
        local trader_formspec = table.concat(formspec, "")
        minetest.show_formspec(clicker:get_player_name(), "fl_wildlife:trader_formspec", trader_formspec)
    end,

   --more mte properties
    on_punch=function(self, puncher, time_from_last_punch, tool_capabilities, dir)
        local hvel = vector.multiply(vector.normalize({x=dir.x,y=0,z=dir.z}),4)
        fl_wildlife.flash_color(self)
        self.object:set_velocity({x=hvel.x,y=2,z=hvel.z})
        mobkit.make_sound(self,'hurt')
        mobkit.hurt(self,tool_capabilities.damage_groups.fleshy or 1)
        if mobkit.is_alive(self) then
            mobkit.hq_runfrom(self,10,puncher)
        end
    end,
})

--fl_wildlife.egg_it("fl_wildlife:trader", "trader", "#3c521d")