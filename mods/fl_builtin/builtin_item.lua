local floor = math.floor
local min = math.min
local item_health = 8
local on_step = minetest.registered_entities["__builtin:item"].on_step
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
    --minetest.chat_send_all("test")
    if not self._memory.thing then self._memory.thing = 1 end
    if timer(self, 1) and core.get_item_group(self.itemstring, "unburnable") == 0 then
        local node = minetest.get_node_or_nil(self.object:get_pos()) or {name = "*"}
        local def = minetest.registered_nodes[node.name] or {}
        if def.damage_per_second then self._memory.health = self._memory.health - def.damage_per_second end

        if self._memory.health <= 0 then self.object:remove() return end
    end

    self._time_total=self._time_total+self._dtime
    on_step(self, dtime, moveresult)
end