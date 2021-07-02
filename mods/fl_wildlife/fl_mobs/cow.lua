function cow_brain(self)
    if mobkit.timer(self,1) then fl_wildlife.node_dps_dmg(self) end --if in nodes with damage take damage
    mobkit.vitals(self)

    if self.hp <= 0 then --kill self if 0 hp
        minetest.add_item(mobkit.get_stand_pos(self), "fl_wildlife:leather " .. math.random(3))

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

minetest.register_entity("fl_wildlife:cow", {
    --mte object properties
    initial_properties = {
        physical = true,
        stepheight = 1.2,
        collide_with_objects = true,
        collisionbox = {-0.5, 0, -0.5, 0.5, 1.5, 0.5},
        visual = "mesh",
        mesh = "farlands_mob_cow.b3d",
        textures = {"farlands_mob_cow.png"},
        --visual_size = {x=1.6, y=1.6},
        static_save = true,
        damage_texture_modifier = "^[colorize:#FF000040"
    },

    on_step = mobkit.stepfunc, --this is required
    on_activate = fl_wildlife.actfunc, --this is required as well(useing custom that calls mobkits and adds nametags)
    get_staticdata = mobkit.statfunc, --who knows, no documentation (probably save entity data)

    --mobkit properties
    buoyancy = 0, --how it works in water
    max_speed = 2, --how fast it can go
    jump_height = 1, --jumping height? not sure how this is different from mte stepheight
    view_range = 24, --how far it can see
    lung_capacity = 10, --seconds till drowning
    max_hp = 5, --health, not sure how this measured? like player where 2hp = 1 heart?
    armor_groups = {fleshy = 100},
    timeout = 0, --how long inactive till there killed, 0 is never CHANGE THIS
    attack={range=0.5,damage_groups={fleshy=3}}, --how close youhave to be to attack?
    --no sounds atm
    animation = { --animations, no idea what these are
        --speed = {range = {x=1,y=16}, speed = 1.5, loop = true},
        stand = {range = {x=1,y=21}, speed = 7, loop = true}, --aka eating
        walk = {range = {x=60,y=80}, speed = 15, loop = true},
        run = {range = {x=30,y=50}, speed = 50, loop = true},
        --punch = {range = {x=45,y=65}, speed = 10, loop = true},
    },

    brainfunc = cow_brain,
    _egg_it = {"cow", "#100c0c"},

    bucket = function(itemstack, user, self)
        --very op, needs some time limit till can be milked again
        local inv = user:get_inventory()
        if inv:room_for_item("main", {name = "fl_bucket:milk"}) then
            inv:add_item("main", "fl_bucket:milk")
        else
            minetest.add_item(mobkit.get_stand_pos(self), "fl_bucket:milk")
        end

        --needs creative check
        itemstack:take_item()
        return itemstack
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
        fl_wildlife.rclick_name(self, clicker)
    end,
})

--fl_wildlife.egg_it("fl_wildlife:cow", "cow", "#100c0c")