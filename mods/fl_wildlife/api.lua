--drop settings
function fl_wildlife.drops(setting_name)
    local input = minetest.settings:get(setting_name)
    --local input = "default:wood, default:wood,default:wood"
    if not input then return nil end

    local drops_table = {}
    for i in string.gmatch(input, "([^,]+)") do
        i = i:gsub("%s+", "")
        if minetest.registered_nodes[i] then
            table.insert(drops_table, i)
        else
            minetest.log("error", "[farlands_npc] '" .. i .. "' is not a registered node")
        end
    end

    return drops_table
end

--dirty dev egg registration
function fl_wildlife.egg_it(t_name, d_name, color)
    minetest.register_craftitem("fl_wildlife:" .. d_name .. "_egg", {
        description = "spawn egg for " .. d_name,
        inventory_image = "farlands_egg.png^(farlands_egg_overlay.png^[colorize:" .. color .. ")", --"404.png",
        stack_max = 99,
        on_place = function(itemstack, placer, pointed_thing)
            local ent = minetest.add_entity(pointed_thing.above, t_name)
            if itemstack:get_meta():get_string("description") ~= "" then
                local self = ent:get_luaentity()
                self.object:set_properties({nametag = itemstack:get_meta():get_string("description"),})
                mobkit.remember(self,"nametag",itemstack:get_meta():get_string("description"))
            end
        end,
    })
end

--used from wildlife demo
function fl_wildlife.node_dps_dmg(self)
	local pos = self.object:get_pos()
	local box = self.object:get_properties().collisionbox
	local pos1 = {x = pos.x + box[1], y = pos.y + box[2], z = pos.z + box[3]}
	local pos2 = {x = pos.x + box[4], y = pos.y + box[5], z = pos.z + box[6]}
	local nodes_overlap = mobkit.get_nodes_in_area(pos1, pos2)
	local total_damage = 0

	for node_def, _ in pairs(nodes_overlap) do
		local dps = node_def.damage_per_second
		if dps then
			total_damage = math.max(total_damage, dps)
		end
	end

	if total_damage ~= 0 then
		mobkit.hurt(self, total_damage)
	end
end

function fl_wildlife.hq_npc_roam(self, prty)
    local func = function(self)
        local factor = math.random(20)
        local pos = mobkit.get_stand_pos(self)
		--local neighbor = math.random(8)
        --local neighbor = math.random(10,30)
        local neighbor = mobkit.neighbor_shift(factor, 30)

		local height, tpos, liquidflag = mobkit.is_neighbor_node_reachable(self,neighbor)
        --[[
        if tpos then
            tpos.x = tpos.x + 20
            tpos.y = tpos.y + 20
        end
        --]]
        --if tpos then minetest.chat_send_all(minetest.pos_to_string(tpos)) end
		--if height and not liquidflag then mobkit.dumbstep(self,height,tpos,0.3,0) end
        if height and not liquidflag then mobkit.goto_next_waypoint(self, tpos) end
        --[[
        if height and not liquidflag then
            if mobkit.is_queue_empty_low(self) and self.isonground then
                if vector.distance(pos,tpos) > 3 then
                    mobkit.goto_next_waypoint(self,tpos)
                else
                    return true
                end
            end
        end
        --]]
    end
    mobkit.queue_high(self, func, prty)
end

--color and duration are optional fields
function fl_wildlife.flash_color(self, cvalue, duration)
    local color = cvalue or "#FF000040"
    self.object:settexturemod("^[colorize:" .. color)
    minetest.after(duration or 0.2, function()
        if mobkit.exists(self) then
            self.object:settexturemod("")
        end
    end)
end

function fl_wildlife.actfunc(self, staticdata, dtime_s)
    mobkit.actfunc(self, staticdata, dtime_s)
    self.nametag = mobkit.recall(self, "nametag") or ""
    self.object:set_properties({nametag = self.nametag,})
end

function fl_wildlife.set_nametag(self, name)
    self.object:set_properties({nametag = name,})
    mobkit.remember(self,"nametag",name)
end

--todo: make this set mobs to not despawn(currently bypassed by making mobs never despawn)
--in theory the engine removes entities if there is to many in a block based on some setting
function fl_wildlife.rclick_name(self, clicker)
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
    end
end

function fl_wildlife.hq_die(self)
	local timer = 1.5
	local start = true
	local func = function(self)
		if start then
			mobkit.lq_fallover(self)
			self.logic = function(self) end	-- brain dead as well
			start=false
		end
		timer = timer-self.dtime
		if timer < 0 then self.object:remove() end
	end
	mobkit.queue_high(self,func,100)
end