--need to make stuff add wear and take items, make sheep eat grass when that gets introduced
function sheep_actfunc(self, staticdata, dtime_s)
    fl_wildlife.actfunc(self, staticdata, dtime_s)
    self.sheep_color = mobkit.recall(self, "sheep_color") or nil
    self.sheep_time = mobkit.recall(self, "sheep_time") or nil
    if self.sheep_color and self.sheep_time then
        if tonumber(self.sheep_time) > dtime_s then
            --minetest.chat_send_all("sheep_time: " .. tonumber(self.sheep_time) .. ", dtime_s: " .. dtime_s)
            self.object:set_properties({textures = {"farlands_mob_sheep_base.png^farlands_mob_sheep_shaved.png"}})

            minetest.after(tonumber(self.sheep_time), function()
                if mobkit.is_alive(self) then
                    self.object:set_properties(
                        {textures = {"farlands_mob_sheep_base.png^farlands_mob_sheep_" .. self.sheep_color .. ".png"}}
                    )
                    mobkit.forget(self,"sheep_time")
                    self.sheep_time = nil
                end
            end)
        end
    elseif self.sheep_color then
        self.object:set_properties(
            {textures = {"farlands_mob_sheep_base.png^farlands_mob_sheep_" .. self.sheep_color .. ".png"}}
        )
    end
end

function sheep_brain(self)
    if mobkit.timer(self,1) then fl_wildlife.node_dps_dmg(self) end --if in nodes with damage take damage
    mobkit.vitals(self)

    if self.hp <= 0 then --kill self if 0 hp

        for counter, dyes in pairs(fl_dyes.dyes) do
            if dyes[1] == string.sub(self.object:get_properties().textures[1], 48, -5) then
                local item = ItemStack(minetest.itemstring_with_palette("fl_wool:wool", counter - 1))
                item:get_meta():set_string("description", fl_dyes.dyes[counter][2] .. " wool")
                item:set_count(math.random(3))
                minetest.add_item(mobkit.get_stand_pos(self), item:to_string())
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

local sheep_textures = {}

for counter, dyes in pairs(fl_dyes.dyes) do
    table.insert(
        sheep_textures,
        "farlands_mob_sheep_base.png^farlands_mob_sheep_" .. fl_dyes.dyes[counter][1] .. ".png"
    )
end

minetest.register_entity("fl_wildlife:sheep", {
    --mte object properties
    initial_properties = {
        physical = true,
        stepheight = 1.1,
        collide_with_objects = true,
        collisionbox = {-0.4, 0, -0.4, 0.4, 1.3, 0.4},
        visual = "mesh",
        mesh = "farlands_mob_sheep.b3d",
        --[[
        textures = {
            "farlands_mob_sheep_base.png^farlands_mob_sheep_white.png",
            "farlands_mob_sheep_base.png^farlands_mob_sheep_black.png",
            "farlands_mob_sheep_base.png^farlands_mob_sheep_blue.png",
            "farlands_mob_sheep_base.png^farlands_mob_sheep_black.png",
        },
        --]]
        textures = sheep_textures,
        --visual_size = {x=1.6, y=1.6},
        static_save = true,
        damage_texture_modifier = "^[colorize:#FF000040"
    },

    on_step = mobkit.stepfunc, --this is required
    on_activate = sheep_actfunc, --this is required as well(useing custom that calls mobkits and adds nametags)
    get_staticdata = mobkit.statfunc, --who knows, no documentation (probably save entity data)

    --mobkit properties
    buoyancy = 0, --how it works in water
    max_speed = 2, --how fast it can go
    jump_height = 1.1, --jumping height? not sure how this is different from mte stepheight
    view_range = 24, --how far it can see
    lung_capacity = 10, --seconds till drowning
    max_hp = 5, --health, not sure how this measured? like player where 2hp = 1 heart?
    armor_groups = {fleshy = 100},
    timeout = 0, --how long inactive till there killed, 0 is never CHANGE THIS
    attack={range=0.5,damage_groups={fleshy=3}}, --how close youhave to be to attack?
    --no sounds atm
    animation = { --animations, no idea what these are
        --speed = {range = {x=1,y=16}, speed = 1.5, loop = true},
        stand = {range = {x=1,y=25}, speed = 7, loop = true}, --aka eating
        walk = {range = {x=25,y=45}, speed = 16, loop = true},
        run = {range = {x=27,y=46}, speed = 50, loop = true},
        --punch = {range = {x=45,y=65}, speed = 10, loop = true},
    },

    brainfunc = sheep_brain,--villager_brain, --function for the brain
    _egg_it = {"sheep", "#a49b95"},
    _spawning = {
        rarity = 0.75,
        light_min = 11,
        cluster = 3,
    },
    _on_spawn=function(ent)
        local self = ent:get_luaentity()
        self.sheep_color = "white"
        if math.random() < 0.1 then self.sheep_color = "black" end

        mobkit.remember(self,"sheep_color", self.sheep_color)
        ent:set_properties(
            {textures = {"farlands_mob_sheep_base.png^farlands_mob_sheep_" .. self.sheep_color .. ".png"}}
       )
    end,

    --more mte properties
    on_punch=function(self, puncher, time_from_last_punch, tool_capabilities, dir)
        local hvel = vector.multiply(vector.normalize({x=dir.x,y=0,z=dir.z}),4)
        fl_wildlife.flash_color(self)
        self.object:set_velocity({x=hvel.x,y=2,z=hvel.z})
        mobkit.make_sound(self,'hurt')
        mobkit.hurt(self,tool_capabilities.damage_groups.fleshy or 1)
        --minetest.chat_send_all(string.sub(self.object:get_properties().textures[1], 48, -5))
        if mobkit.is_alive(self) then
            mobkit.hq_runfrom(self,10,puncher)
        end
    end,

    on_rightclick = function(self, clicker)
        local itemstack = clicker:get_wielded_item()
        if itemstack:get_name() == "fl_wildlife:nametag" then
            local meta = itemstack:get_meta()
            local mName
            if meta:get_string("description") == "" then
                mName = clicker:get_player_name() .. "'s mob"
            else
                mName = meta:get_string("description")
            end

            fl_wildlife.set_nametag(self, mName)

            if not minetest.settings:get_bool("creative_mode") then
                itemstack:take_item(1)
                clicker:set_wielded_item(itemstack)
            end
        elseif itemstack:get_name() == "fl_tools:shears" then
            --note that tools dont have animations pointed at objects for some reason
            local shaved_sheep = "farlands_mob_sheep_base.png^farlands_mob_sheep_shaved.png"
            if self.object:get_properties().textures[1] == shaved_sheep then return end

            --drop wool, shave sheep
            --add wear to the tool if survival
            local sc = string.sub(self.object:get_properties().textures[1], 48, -5)
            for counter, dyes in pairs(fl_dyes.dyes) do
                if dyes[1] == sc then
                    local item = ItemStack(minetest.itemstring_with_palette("fl_wool:wool", counter - 1))
                    item:get_meta():set_string("description", fl_dyes.dyes[counter][2] .. " wool")
                    minetest.add_item(mobkit.get_stand_pos(self), item:to_string())
                    self.object:set_properties({textures = {shaved_sheep}})
                    mobkit.remember(self,"sheep_color",sc)
                    self.sheep_color = sc
                end
            end

            local after_time = math.random(15,45)
            --minetest.chat_send_all(after_time)
            mobkit.remember(self,"sheep_time",after_time)
            minetest.after(after_time, function()
                if mobkit.is_alive(self) then
                    self.object:set_properties(
                        {textures = {"farlands_mob_sheep_base.png^farlands_mob_sheep_" .. sc .. ".png"}}
                    )
                    mobkit.forget(self,"sheep_time")
                    self.sheep_time = nil
                end
            end)
        elseif string.sub(itemstack:get_name(), 1, 7) == "fl_dyes" then
            local shaved_sheep = "farlands_mob_sheep_base.png^farlands_mob_sheep_shaved.png"
            if self.object:get_properties().textures[1] == shaved_sheep then return end

            --minetest.chat_send_all(string.sub(itemstack:get_name(), 9, -1))
            if minetest.get_item_group(itemstack:get_name(), "dye") == 1 then
                --minetest.chat_send_all("in group")
                local sc = string.sub(itemstack:get_name(), 9, -5)

                self.object:set_properties(
                    {textures = {"farlands_mob_sheep_base.png^farlands_mob_sheep_" .. sc .. ".png"}}
                )
                mobkit.remember(self,"sheep_color",sc)
                self.sheep_color = sc
            end
        end
    end,
})

--fl_wildlife.egg_it("fl_wildlife:sheep", "sheep", "#a49b95")