function fish_brain(self)
    --stuff

    if self.hp <= 0 then --kill self if 0 hp
        minetest.add_item(mobkit.get_stand_pos(self), "fl_wildlife:raw_riverfish")

        mobkit.clear_queue_high(self)
        fl_wildlife.hq_die(self)
        return
    end

    if mobkit.timer(self,1) then
        if not self.isinliquid and not self.isinflowingliquid then
            fl_wildlife.flash_color(self)
            mobkit.hurt(self,1)
        else
            mobkit.animate(self,"walk")
            mobkit.hq_aqua_roam(self,10,1)
        end
    end
end

--very broken fish
minetest.register_entity("fl_wildlife:riverfish", {
    --mte object properties
    physical = true,
    stepheight = 1.1,
    collide_with_objects = false,
    collisionbox = {-0.2, -0.2, -0.2, 0.2, 0.2, 0.2}, --fix this
    visual = "mesh",
    mesh = "farlands_mob_fish.b3d",
    textures = {"farlands_mob_riverfish.png"},
    visual_size = {x=1.6, y=1.6},
    static_save = true,

    --hp_max = 200,

    --mte entity properties
    on_step = fl_wildlife.stepfunc, --this is required
    on_activate = fl_wildlife.actfunc, --this is required as well(useing custom that calls mobkits and adds nametags)
    get_staticdata = mobkit.statfunc, --who knows, no documentation (probably save entity data)

    --mobkit properties
    buoyancy = 0.99, --how it works in water
    max_speed = 2, --how fast it can go
    jump_height = 0, --jumping height? not sure how this is different from mte stepheight
    view_range = 24, --how far it can see
    lung_capacity = 10, --seconds till drowning
    max_hp = 5, --health, not sure how this measured? like player where 2hp = 1 heart?
    armor_groups = {fleshy = 100},
    timeout = 0, --how long inactive till there killed, 0 is never CHANGE THIS
    attack={range=0.5,damage_groups={fleshy=3}}, --how close youhave to be to attack?
    --no sounds atm
    animation = { --animations, no idea what these are
        speed = {range = {x=15,y=20}, speed = 3, loop = true}, --who knows
        stand = {range = {x=1,y=20}, speed = 3, loop = true},
        walk = {range = {x=1,y=20}, speed = 3, loop = true},
        run = {range = {x=1,y=20}, speed = 6, loop = true},
        --punch = {range = {x=45,y=65}, speed = 10, loop = true},
    },

    --custom to this mod
    drops = "fl_wildlife.villager.drops",
    --ignore in spawning for now as water spawning not supported
    _spawn_ignore = true,

    brainfunc = fish_brain,
    _egg_it = {"riverfish", "#978166"},

    bucket = function(itemstack, user, self)
        --note this gives a bucket that can place water, but fish doesnt have to be in water
        local inv = user:get_inventory()
        if inv:room_for_item("main", {name = "fl_bucket:riverfish"}) then
            inv:add_item("main", "fl_bucket:riverfish")
        else
            minetest.add_item(mobkit.get_stand_pos(self), "fl_bucket:riverfish")
        end

        --needs creative check
        self.object:remove()
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
        if mobkit.is_alive(self) then
            mobkit.hq_runfrom(self,10,puncher)
        end
    end,

    on_rightclick = function(self, clicker)
        fl_wildlife.rclick_name(self, clicker)
    end,
})

--register eggs
--fl_wildlife.egg_it("fl_wildlife:riverfish", "riverfish", "#978166")

--fish still jump out,
--fish die in pen on in water on base?
--this ^ is due to water_flowing