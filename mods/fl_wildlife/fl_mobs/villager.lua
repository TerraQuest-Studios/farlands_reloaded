--[[
local function villager_brain(self)
    if mobkit.timer(self,1) then fl_wildlife.node_dps_dmg(self) end --if in nodes with damage take damage
    mobkit.vitals(self)

    if self.hp <= 0 then --kill self if 0 hp
        local item_drops = fl_wildlife.drops("fl_wildlife.villager.drops")
        if item_drops ~= nil then
            for _, i in pairs(item_drops) do
                minetest.add_item(mobkit.get_stand_pos(self), i)
            end
        end

        mobkit.clear_queue_high(self)
        mobkit.hq_die(self)
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
            --fhq_roam(self, 1)
        end

    end

end
--]]

minetest.register_entity("fl_wildlife:villager", {
    --mte object properties
    physical = true,
    stepheight = 1.1,
    collide_with_objects = true,
    collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3}, --top y set to 1.99 to walk under 2 nodes
    visual = "mesh",
    mesh = "farlands_npc_villager.b3d",
    textures = {"farlands_npc_villager1.png", "farlands_npc_villager2.png"},
    visual_size = {x = 0.9, y = 0.9, z = 0.9},
    static_save = true,

    --hp_max = 200,

    --mte entity properties
    on_step = mobkit.stepfunc, --this is required
    on_activate = fl_wildlife.actfunc, --this is required as well(useing custom that calls mobkits and adds nametags)
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

    --custom to this mod
    drops = "fl_wildlife.villager.drops",

    brainfunc = fl_brains.villager_brain,--villager_brain, --function for the brain
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
    end,
})

--register eggs
--fl_wildlife.egg_it("fl_wildlife:villager", "villager", "#654321")