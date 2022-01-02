local floor = math.floor
local min = math.min
local item_health = 8
local lifespan = tonumber(core.settings:get("item_entity_ttl")) or 900
--local on_step = minetest.registered_entities["__builtin:item"].on_step
local on_activate = minetest.registered_entities["__builtin:item"].on_activate
local get_staticdata = minetest.registered_entities["__builtin:item"].get_staticdata

--taken from mobkit
function timer(self,s) -- returns true approx every s seconds
	local t1 = floor(self._time_total)
	local t2 = floor(self._time_total+self._dtime)
	if t2>t1 and t2%s==0 then return true end
end

minetest.registered_entities["__builtin:item"].get_staticdata = function(self)
    local data = {_memory = self._memory}
    data._old = get_staticdata(self)
    return core.serialize(data)
end

minetest.registered_entities["__builtin:item"].on_activate = function(self, staticdata, dtime_s)
    local data = core.deserialize(staticdata) or {}
    if data._memory then self._memory = data._memory else self._memory = {} end

    self._time_total = 0
    self._memory.health = self._memory.health or item_health

    on_activate(self, data._old or "", dtime_s)
end

minetest.registered_entities["__builtin:item"].on_step = function(self, dtime, moveresult)
    self._dtime = min(dtime,0.2)
    self.age = self.age + dtime
    self._freeze = true
    local pos = self.object:get_pos()
    local node = minetest.get_node_or_nil(pos) or {name = "*", param2 = 0}

    --kill if to old
    if lifespan > 0 and self.age > lifespan then
        self.object:remove()
        return
    end

    --item input injects (for machines, injectors)
    if moveresult.collides and self.conveyor then
        if moveresult.collisions[1] and moveresult.collisions[1].type == "node" then
            local cpos = moveresult.collisions[1].node_pos
            local cnode = minetest.get_node(cpos)
            local cdef = minetest.registered_nodes[cnode.name]

            if minetest.get_item_group(cnode.name, "item_input") >= 1
            and cdef._allow_input(cnode.param2, node.param2) then
                local istack = ItemStack(self.itemstring)
                cdef._item_input(cpos, cnode, istack)
                self.object:remove()
                --return
                --minetest.chat_send_all(cnode.name)
                return
            end
        end
    end

    --burning code
    if not self._memory.thing then self._memory.thing = 1 end
    if timer(self, 1) and core.get_item_group(self.itemstring, "unburnable") == 0 then
        --local node = minetest.get_node_or_nil(pos) or {name = "*"}
        local def = minetest.registered_nodes[node.name] or {}
        if def.damage_per_second then self._memory.health = self._memory.health - def.damage_per_second end

        if self._memory.health <= 0 then self.object:remove() return end
    end

    --floating code
    self.isinliquid = false
    self.isinflowingliquid = false
    --local node = minetest.get_node_or_nil(pos) or {name = "*"}
    local def = minetest.registered_nodes[node.name] or {}
    if def.drawtype == "liquid" then
        self.isinliquid = true
    elseif def.drawtype == "flowingliquid" then
        self.isinflowingliquid = true
    end

    if self.isinliquid and self.object:get_velocity().y < 1 then
        --snap to center
        if pos.x ~= math.floor(pos.x+0.5) or pos.z ~= math.floor(pos.z+0.5) then
            self.object:set_pos(vector.new(math.floor(pos.x+0.5), pos.y, math.floor(pos.z+0.5)))
        end

        local oldv = self.object:get_velocity()
        self.object:add_velocity(vector.new(-oldv.x,1,-oldv.z))
        self._freeze = false
    --[[
    elseif self.isinflowingliquid then
        local oldv = self.object:get_velocity()
        local level = core.get_node_level(pos)
        minetest.chat_send_all(math.floor(pos.y+0.1)+level/8 .. " " .. pos.y .. " " .. level)
        if math.floor(pos.y+0.1)+level/8 >= pos.y then
            minetest.chat_send_all("true")
            self.object:add_velocity(vector.new(-oldv.x,1,-oldv.z))
        end
        --]]
    end

    --conveyor code
    if string.find(node.name, "fl_industrial:conveyor") then
        local dir = core.facedir_to_dir(node.param2)

        --center on conveyor
        if dir.x == 0 and pos.x ~= math.floor(pos.x+0.5) then
            self.object:set_pos(vector.new(math.floor(pos.x+0.5), pos.y, pos.z))
        elseif dir.z == 0 and pos.z ~= math.floor(pos.z+0.5) then
            self.object:set_pos(vector.new(pos.x, pos.y, math.floor(pos.z+0.5)))
        end

        self.object:set_velocity(dir)
        self.conveyor = {true, 10, dir}
        self._freeze = false
    elseif self.conveyor and self.conveyor[1] then
        if self.conveyor[2] == 0 then
            if self.conveyor[3].x == self.object:get_velocity().x
            or self.conveyor[3].z == self.object:get_velocity().z then
                self.object:set_velocity(vector.new(0,0,0))
            end
            self.conveyor = nil
        else
            self.conveyor[2] = self.conveyor[2] - 1
            self._freeze = false
        end
    end

    --collision stop
    if self._freeze and moveresult.collides then
        if not vector.equals(vector.new(0,0,0), self.object:get_velocity()) then
            self.object:set_velocity(vector.new(0,0,0))
        end
    end

    --merge items
    local own_stack = ItemStack(self.itemstring)
    if vector.equals(self.object:get_velocity(), vector.new(0,0,0)) and own_stack:get_free_space() ~= 0 then
        local objs = core.get_objects_inside_radius(pos, 1.0)
        for _, obj in pairs(objs) do
            local ent = obj:get_luaentity()
            if ent and ent.name == "__builtin:item" then
                self:try_merge_with(own_stack, obj, ent)
            end
        end
    end

    self._time_total=self._time_total+self._dtime
    --on_step(self, dtime, moveresult)
end