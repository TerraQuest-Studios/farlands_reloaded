local abr = minetest.get_mapgen_setting('active_block_range')

-- custom behaviour
-- makes them move in stimulus' general direction for limited time
local function hq_attracted(self,prty,tpos)
	local timer = os.time() + math.random(10,20)	-- zombie's attention span
	local func = function()
		if os.time() > timer then return true end
		if mobkit.is_queue_empty_low(self) and self.isonground then
			local pos = mobkit.get_stand_pos(self)
			if vector.distance(pos,tpos) > 3 then
				mobkit.goto_next_waypoint(self,tpos)
			else
				return true
			end
		end
	end
	mobkit.queue_high(self,func,prty)
end

local function alert(pos)
	local objs = minetest.get_objects_inside_radius(pos,abr*16)
	for _,obj in ipairs(objs) do
		if not obj:is_player() then
			local luaent = obj:get_luaentity()
			if luaent and luaent.name == 'zombiestrd:zombie' then
				hq_attracted(luaent,10,pos)
			end
		end
	end
end

function cc_brain(self)
    if mobkit.timer(self,1) then fl_wildlife.node_dps_dmg(self) end --if in nodes with damage take damage
    mobkit.vitals(self)

    if self.hp <= 0 then --kill self if 0 hp
        --minetest.add_item(mobkit.get_stand_pos(self), "fl_wildlife:leather " .. math.random(3))

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

        local pos=self.object:get_pos()

		if prty < 20 then
			local plyr=mobkit.get_nearby_player(self)
			if plyr then
				local pos2 = plyr:get_pos()
				if prty < 10 then	-- zombie not alert
					if vector.distance(pos,pos2) < self.view_range/3 and
					(not mobkit.is_there_yet2d(pos,minetest.yaw_to_dir(self.object:get_yaw()),pos2) or
					vector.length(plyr:get_player_velocity()) > 3) then
						mobkit.make_sound(self,'misc')
						mobkit.hq_hunt(self,20,plyr)
						if math.random()<=0.5 then alert(pos) end
					end
				else
					if vector.distance(pos,pos2) < self.view_range then
						mobkit.make_sound(self,'misc')
						mobkit.hq_hunt(self,20,plyr)
						if math.random()<=0.5 then alert(pos) end
					end
				end
			end
		end

        if mobkit.is_queue_empty_high(self) then
            --mobkit.animate(self, "walk")
            mobkit.hq_roam(self,0)
            --fl_wildlife.hq_npc_roam(self, 0)
        end

    end

end

minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
	if math.random()<=0.1 then
		alert(pos)
	end
end)

minetest.register_entity("fl_wildlife:cavecrab", {
    --mte object properties
    initial_properties = {
        physical = true,
        stepheight = 1.2,
        collide_with_objects = true,
        collisionbox = {-0.5, 0, -0.5, 0.5, 1.5, 0.5},
        visual = "mesh",
        mesh = "farlands_mob_cavecrab.b3d",
        textures = {"farlands_mob_cavecrab.png"},
        --visual_size = {x=1.6, y=1.6},
        static_save = true,
        damage_texture_modifier = "^[colorize:#FF000040"
    },

    on_step = fl_wildlife.stepfunc, --this is required
    on_activate = fl_wildlife.actfunc, --this is required as well(useing custom that calls mobkits and adds nametags)
    get_staticdata = mobkit.statfunc, --who knows, no documentation (probably save entity data)

    --mobkit properties
    buoyancy = 0, --how it works in water
    max_speed = 2, --how fast it can go
    jump_height = 1, --jumping height? not sure how this is different from mte stepheight
    view_range = 24, --how far it can see
    lung_capacity = 10, --seconds till drowning
    max_hp = 5, --health, not sure how this measured? like player where 2hp = 1 heart?
    --armor_groups = {fleshy = 100},
    timeout = 0, --how long inactive till there killed, 0 is never CHANGE THIS
    attack={range=0.9,damage_groups={fleshy=7}}, --how entity needs to be to attack+damage
    armor_groups={immortal=100},
    --no sounds atm
    animation = { --animations, no idea what these are
        --speed = {range = {x=1,y=16}, speed = 1.5, loop = true},
        stand = {range = {x=45,y=65}, speed = 7, loop = true}, --aka eating
        walk = {range = {x=20,y=40}, speed = 15, loop = true},
        run = {range = {x=20,y=40}, speed = 50, loop = true},
        --punch = {range = {x=45,y=65}, speed = 10, loop = true},
    },

    brainfunc = cc_brain,
    _spawner = {},

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

fl_wildlife.egg_it("fl_wildlife:cavecrab", "cavecrab", "#76716f")