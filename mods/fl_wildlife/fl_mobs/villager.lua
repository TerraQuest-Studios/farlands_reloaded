local sstep = minetest.settings:get("dedicated_server_step") or 0.09
local creative = minetest.settings:get_bool("creative_mode", false)
local random = math.random

local function actfunc(self, staticdata, dtime_s)
    fl_wildlife.actfunc(self, staticdata, dtime_s)
    self.axe = mobkit.recall(self, "axe")
end

local function axe_behavior(self,priority)
    local function use_axe()
        if not creative then
            self.axe[2] = self.axe[2] - 1
            if self.axe[2] == 1 then
                local pos = self.object:get_pos()
                local anvil = minetest.find_nodes_in_area(
                    vector.new(pos.x+5, pos.y+5, pos.z+5),
                    vector.new(pos.x-5, pos.y-5, pos.z-5),
                    "fl_workshop:anvil"
                )
                if #anvil >= 1 then
                    self.axe[2] = minetest.registered_items[self.axe[1]].tool_capabilities.groupcaps.dig_tree.uses
                end
            end
        end
    end

    local function dig_node(pos)
        local node = minetest.get_node_or_nil(pos)
        if not node then return end

        if minetest.get_item_group(node.name, "trunk") >= 1 then
            minetest.set_node(pos, {name = "air"})
            --direct access to mobkit memeory
            if not self.memory.inv then self.memory.inv = {} end
            if not self.memory.inv[node.name] then
                self.memory.inv[node.name] = 1
            else
                self.memory.inv[node.name] = self.memory.inv[node.name] + 1
            end
        end
    end

    local function dispose_inv()
        minetest.chat_send_all("triggered")
        for name, count in pairs(self.memory.inv) do
            if count < 99 then
                minetest.add_item(self.object:get_pos(), name .. " " .. count)
            else
                local stacks = count/99
                for i = 1, math.abs(stacks) do
                    minetest.add_item(self.object:get_pos(), name .. " 99")
                end
                if math.abs(stacks) ~= stacks then
                    minetest.add_item(self.object:get_pos(), name .. " " .. stacks-math.abs(stacks))
                end
            end
        end
    end

    local nodes = {}
    local init = true
    local turn = 0
    local function func()
        if init then
            local pos = self.object:get_pos()
            nodes = minetest.find_nodes_in_area(
                vector.new(pos.x+7, pos.y+5, pos.z+7),
                vector.new(pos.x-7, pos.y-5, pos.z-7),
                "group:trunk"
            )
            init = false

            if #nodes == 0 then return true end
        end

        --[[
            in thoery you should never get here, but some how it does on occasion
            so this is to prevent a crash, we reach point "end behavior" however
            it keeps going, but this return true somehow works
        --]]
        --minetest.chat_send_all("alive status")
        if not self.axe then
            minetest.chat_send_all("in theory never get here")
            return true
        end

        if turn <= 1 and self.axe[2] > 0 then
            if not minetest.is_protected(nodes[#nodes], "") then
                --minetest.dig_node(nodes[#nodes])
                dig_node(nodes[#nodes])
                use_axe()
            end
            nodes[#nodes] = nil
        elseif self.axe[2] == 0 then
            self.axe = nil
            mobkit.forget(self, "axe")
            dispose_inv()
            return true
        --[[
        --punch animation
        elseif turn > math.floor((1/sstep)*3)-1 then
            mobkit.animate(self, "punch")
            turn = turn - 1
            return false
        --]]
        else
            turn = turn - 1
            return false
        end

        if #nodes == 0 then
            if not creative then
                mobkit.remember(self, "axe", self.axe)
            else
                mobkit.forget(self, "axe")
                self.axe = nil
            end
            dispose_inv()
            minetest.chat_send_all("end behavior")
            return true
        end

        mobkit.lq_turn2pos(self, nodes[#nodes])
        turn = math.floor((1/sstep)*3) --roughly 30 seconds
        --minetest.chat_send_all(#nodes)

    end
    mobkit.queue_high(self,func,priority)
end

local function villager_brain(self)
    if mobkit.timer(self,1) then fl_wildlife.node_dps_dmg(self) end --if in nodes with damage take damage
    mobkit.vitals(self)

    if self.hp <= 0 then --kill self if 0 hp

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

        if self.axe and random(100) > 95 then
            axe_behavior(self, 30)
        end

        if mobkit.is_queue_empty_high(self) then
            mobkit.hq_roam(self,0)
        end

    end

end

minetest.register_entity("fl_wildlife:villager", {
    --mte object properties
    initial_properties = {
        physical = true,
        stepheight = 1.1,
        collide_with_objects = true,
        collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
        visual = "mesh",
        mesh = "farlands_npc_villager.b3d",
        textures = {"farlands_npc_villager1.png", "farlands_npc_villager2.png"},
        visual_size = {x = 0.9, y = 0.9, z = 0.9},
        static_save = true,
        --damage_texture_modifier = "^[colorize:#FF000040"
    },

    --hp_max = 200,

    --mte entity properties
    on_step = mobkit.stepfunc, --this is required
    on_activate = actfunc, --this is required as well(useing custom that calls mobkits and adds nametags)
    get_staticdata = mobkit.statfunc, --who knows, no documentation (probably save entity data)

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
        speed = {range = {x=18,y=27}, speed = 1.5, loop = true},
        stand = {range = {x=1,y=20}, speed = 10, loop = true},
        walk = {range = {x=25,y=45}, speed = 10, loop = true},
        run = {range = {x=70,y=90}, speed = 50, loop = true},
        punch = {range = {x=45,y=65}, speed = 10, loop = true},
    },

    brainfunc = villager_brain,--villager_brain, --function for the brain
    _egg_it = {"villager", "#654321"},

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

    on_rightclick = function(self, clicker)
        fl_wildlife.rclick_name(self, clicker)

        local item = clicker:get_wielded_item():get_name()
        if minetest.get_item_group(item, "axe") then
            self.axe = {
                clicker:get_wielded_item():get_name(),
                minetest.registered_items[item].tool_capabilities.groupcaps.dig_tree.uses
            }
            mobkit.remember(self, "axe", self.axe)
        end
    end,
})

--register eggs
--fl_wildlife.egg_it("fl_wildlife:villager", "villager", "#654321")