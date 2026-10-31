local rail = fl_trains.rail

-- gap between coupled or touching vehicles
local gap = 1/8
local max_speed = 10
local acceleration = 2
local brake_force = 6
local friction = 0.4
-- pull along the track on a slope, scaled by how steep it is. while the train is
-- being driven it is shared between its engines
local gravity = 1.5
-- how far from a train end other vehicles are looked for
local search_range = 3
-- how often a moving train looks for trains touching its ends
local touch_interval = 0.25
local chain_height = -0.37

--[[
    a train is any group of vehicles moving together, a lone cart is a train too.
    the first vehicle is the leader: its entity steps and saves the whole train and
    the other vehicle entities are not saved, the leader respawns them.

    path: segments the train is on, from the rear to the front. only the leading end
        reads switches, the rest follows the path, so flipping a switch under a train
        can't split it
    before: summed length of every path segment but the last
    head: distance of the first vehicle's center along the last segment
    speed: along the path, positive is towards the front
    slope: average climb of the vehicles towards the front, -1 to 1
    vehicles: {type, flip, owner, car, object}, front to back. flip is set when the
        vehicle faces the rear, car is the cargo of a cart (see vehicle.lua)
    offsets: distance from the first vehicle's center to each vehicle's center
    engines: how many vehicles can drive
    chains: chain entities between coupled vehicles, chains[i] is behind vehicle i
    end_chains: chain entities to a touching train, [1] at the front, [-1] at the rear
]]

-- type name -> {entity, length, can_drive, on_adopt}
fl_trains.vehicle_types = {}
local types = fl_trains.vehicle_types

local function valid(obj)
    return obj and obj:get_pos() ~= nil
end

local function vehicle_length(v)
    return types[v.type].length
end

local function update_offsets(train)
    local offsets, d, engines = {}, 0, 0
    for i, v in ipairs(train.vehicles) do
        if i > 1 then
            d = d + vehicle_length(train.vehicles[i - 1]) / 2 + gap + vehicle_length(v) / 2
        end
        offsets[i] = d
        if types[v.type].can_drive then
            engines = engines + 1
        end
    end
    train.offsets, train.engines = offsets, engines
end

local function rear_need(train)
    return train.offsets[#train.offsets]
end

local function index_of(train, vehicle)
    for i, v in ipairs(train.vehicles) do
        if v == vehicle then return i end
    end
end

-- vehicle at the front (1) or rear (-1) of the train
local function end_vehicle(train, which)
    return train.vehicles[which == 1 and 1 or #train.vehicles]
end

--
-- moving along the path
--

local function recount_before(train)
    local d = 0
    for i = 1, #train.path - 1 do
        d = d + rail.length(train.path[i])
    end
    train.before = d
end

-- distance from the start of the path to the first vehicle
local function covered(train)
    return train.before + train.head
end

-- segment, distance along it and segment index at `back` behind the first vehicle
local function locate(train, back)
    local path = train.path
    local i, d = #path, train.head - back
    while d < 0 and i > 1 do
        i = i - 1
        d = d + rail.length(path[i])
    end
    return path[i], math.max(d, 0), i
end

-- like locate, for increasing distances in a single pass over the path
local function walker(train)
    local path = train.path
    local i, offset = #path, train.head
    return function(back)
        local d = offset - back
        while d < 0 and i > 1 do
            i = i - 1
            offset = offset + rail.length(path[i])
            d = offset - back
        end
        return path[i], math.max(d, 0)
    end
end

-- extends the path behind the train to reach `back`, returns how much it falls short
local function cover_rear(train, back)
    local missing = back - covered(train)
    while missing > 0 do
        local prev = rail.prev(train.path[1])
        if not prev then return missing end
        table.insert(train.path, 1, prev)
        train.before = train.before + rail.length(prev)
        missing = missing - rail.length(prev)
    end
    return 0
end

local function trim_rear(train)
    local need = rear_need(train)
    local path = train.path
    while #path > 1 and covered(train) - rail.length(path[1]) >= need do
        train.before = train.before - rail.length(path[1])
        table.remove(path, 1)
    end
end

-- moves the train along the track, returns false if it ran into the end of it
local function move(train, dist)
    local path = train.path
    if dist >= 0 then
        train.head = train.head + dist
        while train.head > rail.length(path[#path]) do
            local nxt = rail.next(path[#path])
            if not nxt then
                train.head = rail.length(path[#path])
                trim_rear(train)
                return false
            end
            train.head = train.head - rail.length(path[#path])
            train.before = train.before + rail.length(path[#path])
            path[#path + 1] = nxt
        end
        trim_rear(train)
        return true
    end

    local missing = cover_rear(train, rear_need(train) - dist)
    train.head = train.head + math.min(dist + missing, 0)
    while train.head < 0 and #path > 1 do
        path[#path] = nil
        train.before = train.before - rail.length(path[#path])
        train.head = train.head + rail.length(path[#path])
    end
    train.head = math.max(train.head, 0)
    return missing == 0
end

-- world position and path direction at `back` behind the first vehicle,
-- extrapolated past both ends of the path
local function position_at(train, back)
    local seg, d = locate(train, math.max(back, 0))
    local pos, dir = rail.transform(seg, d)
    local overshoot = back - covered(train)
    if back < 0 then
        pos = pos - dir * back
    elseif overshoot > 0 then
        pos = pos - dir * overshoot
    end
    return pos, dir
end

-- bumper position and outward direction of the front (1) or rear (-1) of the train
local function end_point(train, which)
    if which == 1 then
        return position_at(train, -vehicle_length(train.vehicles[1]) / 2)
    end
    local n = #train.vehicles
    local pos, dir = position_at(train, train.offsets[n] + vehicle_length(train.vehicles[n]) / 2)
    return pos, -dir
end

-- turns the train around so its rear becomes its front
local function reverse(train)
    trim_rear(train)
    -- where the rear vehicle is along the first segment
    local p = covered(train) - rear_need(train)
    local path, vehicles = {}, {}
    for i = #train.path, 1, -1 do
        path[#path + 1] = rail.reversed(train.path[i])
    end
    for i = #train.vehicles, 1, -1 do
        local v = train.vehicles[i]
        v.flip = not v.flip
        vehicles[#vehicles + 1] = v
    end
    train.path, train.vehicles = path, vehicles
    train.head = rail.length(path[#path]) - p
    train.speed = -train.speed
    train.slope = -train.slope
    local n, chains = #vehicles, {}
    for i, chain in pairs(train.chains) do
        chains[n - i] = chain
    end
    train.chains = chains
    recount_before(train)
    update_offsets(train)
end

--
-- chains
--

local function remove_end_chains(train)
    for which, chain in pairs(train.end_chains) do
        if valid(chain) then chain:remove() end
        train.end_chains[which] = nil
    end
end

local function spawn_chain(pos)
    local obj = core.add_entity(pos, "fl_trains:chain")
    return obj and obj:get_luaentity()
end

local function place_chain(obj, pos, dir, speed)
    pos.y = pos.y + chain_height
    rail.set_transform(obj, pos, dir, speed)
end

-- vehicle end of another train touching the front (1) or rear (-1) of this one,
-- with the gap between them in [min_gap, max_gap]
local function find_touching(train, which, min_gap, max_gap)
    local pos, out = end_point(train, which)
    local best
    for _, obj in ipairs(core.get_objects_inside_radius(pos, search_range)) do
        local ent = obj:get_luaentity()
        local other = ent and ent.vehicle and ent.train
        if other and other ~= train and not other.dead then
            for _, w in ipairs({1, -1}) do
                if end_vehicle(other, w) == ent.vehicle then
                    local other_pos = end_point(other, w)
                    local rel = other_pos - pos
                    local g = vector.dot(rel, out)
                    -- ignore vehicles on other tracks next to this one
                    if vector.length(rel - out * g) < 0.3 and g >= min_gap and g <= max_gap
                        and (not best or g < best.gap)
                    then
                        best = {train = other, which = w, gap = g, pos = other_pos}
                    end
                end
            end
        end
    end
    return best
end

-- shows a faded chain between this train and a train touching it
local function refresh_end_chains(train)
    for _, which in ipairs({1, -1}) do
        local chain = train.end_chains[which]
        local touching = find_touching(train, which, gap - 0.06, gap + 0.06)
        -- the other train may already show one
        if touching and valid(touching.train.end_chains[touching.which]) then
            touching = nil
        end
        if touching then
            local pos, out = end_point(train, which)
            local ent = valid(chain) and chain:get_luaentity() or spawn_chain(pos)
            if ent then
                ent:set_kind(false)
                ent.train, ent.which = train, which
                ent.other, ent.other_which = touching.train, touching.which
                train.end_chains[which] = ent.object
                place_chain(ent.object, (pos + touching.pos) / 2, out * which, train.speed)
            end
        elseif chain then
            if valid(chain) then chain:remove() end
            train.end_chains[which] = nil
        end
    end
end

-- keeps the faded chains at the train's ends in place between refreshes
local function move_end_chains(train)
    for which, chain in pairs(train.end_chains) do
        if valid(chain) then
            local pos, out = end_point(train, which)
            place_chain(chain, pos + out * (gap / 2), out * which, train.speed)
        end
    end
end

--
-- vehicle entities
--

local function adopt(train, i)
    local v = train.vehicles[i]
    local ent = v.object:get_luaentity()
    ent.train, ent.vehicle, ent.spawned = train, v, nil
    v.object:set_properties({static_save = i == 1})
    local on_adopt = types[v.type].on_adopt
    if on_adopt then on_adopt(ent) end
end

local function spawn_vehicle(train, i)
    local v = train.vehicles[i]
    local obj = core.add_entity(position_at(train, train.offsets[i]), types[v.type].entity,
        core.serialize({spawned = true}))
    if not obj then return end
    v.object = obj
    adopt(train, i)
end

-- points every vehicle entity at the train, the first one saves it
local function adopt_all(train)
    for i, v in ipairs(train.vehicles) do
        if valid(v.object) then
            adopt(train, i)
        elseif i == 1 then
            spawn_vehicle(train, i)
        end
    end
end

-- respawns vehicle entities that got unloaded, as long as their mapblock is active
local function respawn_vehicles(train)
    for i, v in ipairs(train.vehicles) do
        if not valid(v.object) then
            local pos = position_at(train, train.offsets[i])
            if not core.compare_block_status or core.compare_block_status(pos, "active") then
                spawn_vehicle(train, i)
            end
        end
    end
end

-- places the vehicles and the chains between them, and works out the slope
local function update_objects(train)
    local vehicles, offsets = train.vehicles, train.offsets
    local at = walker(train)
    local climb, length = 0, 0
    for i, v in ipairs(vehicles) do
        -- the chain in front of vehicle i comes before it along the path
        if i > 1 then
            local pos, dir = rail.transform(at(offsets[i - 1] + vehicle_length(vehicles[i - 1]) / 2 + gap / 2))
            local chain = train.chains[i - 1]
            local ent = valid(chain) and chain:get_luaentity() or spawn_chain(pos)
            if ent then
                ent:set_kind(true)
                ent.train, ent.index = train, i - 1
                train.chains[i - 1] = ent.object
                place_chain(ent.object, pos, dir, train.speed)
            end
        end

        local pos, dir = rail.transform(at(offsets[i]))
        if valid(v.object) then
            rail.set_transform(v.object, pos, dir, train.speed, v.flip)
        end
        climb = climb + dir.y * vehicle_length(v)
        length = length + vehicle_length(v)
    end
    train.slope = climb / length

    for i, chain in pairs(train.chains) do
        if i >= #vehicles then
            if valid(chain) then chain:remove() end
            train.chains[i] = nil
        end
    end
end

local function new_train(train)
    train.chains, train.end_chains = {}, {}
    train.respawn_timer, train.touch_timer = 1, 0
    train.slope = 0
    recount_before(train)
    update_offsets(train)
    return train
end

local function kill(train)
    train.dead = true
    for _, chain in pairs(train.chains) do
        if valid(chain) then chain:remove() end
    end
    train.chains = {}
    remove_end_chains(train)
end

--
-- joining and splitting
--

-- joins train b onto train a where a's end a_which touches b's end b_which.
-- b's vehicles snap to a, fails if they would move more than tolerance
function fl_trains.join(a, a_which, b, b_which, tolerance)
    if a == b or a.dead or b.dead then return false end
    if a_which == 1 then reverse(a) end
    if b_which == -1 then reverse(b) end

    local old_positions = {}
    for i = 1, #b.vehicles do
        old_positions[i] = position_at(b, b.offsets[i])
    end
    local old_path, old_vehicles = {}, {}
    for i, seg in ipairs(a.path) do old_path[i] = seg end
    for i, v in ipairs(a.vehicles) do old_vehicles[i] = v end

    for _, v in ipairs(b.vehicles) do
        a.vehicles[#a.vehicles + 1] = v
    end
    update_offsets(a)
    local ok = cover_rear(a, rear_need(a)) == 0
    for i, pos in ipairs(old_positions) do
        if not ok then break end
        ok = vector.distance(position_at(a, a.offsets[#old_vehicles + i]), pos) <= tolerance
    end
    if not ok then
        a.path, a.vehicles = old_path, old_vehicles
        recount_before(a)
        update_offsets(a)
        trim_rear(a)
        return false
    end

    a.speed = (a.speed * #old_vehicles + b.speed * #b.vehicles) / #a.vehicles
    kill(b)
    remove_end_chains(a)
    trim_rear(a)
    adopt_all(a)
    update_objects(a)
    refresh_end_chains(a)
    return true
end

-- splits the train in front of vehicle index, returns the new rear train
function fl_trains.split(train, index)
    local n = #train.vehicles
    if index < 2 or index > n then return end
    local _, d, k = locate(train, train.offsets[index])
    local rear = {path = {}, head = d, speed = train.speed, vehicles = {}}
    for i = 1, k do
        rear.path[i] = train.path[i]
    end
    for i = index, n do
        rear.vehicles[#rear.vehicles + 1] = train.vehicles[i]
        train.vehicles[i] = nil
    end
    new_train(rear)
    update_offsets(train)

    for i, chain in pairs(train.chains) do
        if i >= index - 1 then
            if valid(chain) then chain:remove() end
            train.chains[i] = nil
        end
    end
    remove_end_chains(train)
    for _, t in ipairs({train, rear}) do
        trim_rear(t)
        adopt_all(t)
        update_objects(t)
    end
    refresh_end_chains(train)
    refresh_end_chains(rear)
    return rear
end

-- takes a vehicle out of its train, the vehicles behind it become their own train
local function remove_vehicle(train, index)
    if index < #train.vehicles then
        fl_trains.split(train, index + 1)
    end
    if index == 1 then
        kill(train)
        return
    end
    train.vehicles[index] = nil
    update_offsets(train)
    trim_rear(train)
    remove_end_chains(train)
    update_objects(train)
    refresh_end_chains(train)
end

-- joins a just placed train to a train it was placed against, if player may
local function join_nearby(train, tolerance, player)
    for _, which in ipairs({1, -1}) do
        if train.dead then return end
        local touching = find_touching(train, which, gap - tolerance, gap + tolerance)
        if touching and (not player
            or fl_trains.can_access(player, end_vehicle(touching.train, touching.which).owner))
        then
            fl_trains.join(touching.train, touching.which, train, which, tolerance)
        end
    end
end

--
-- stepping
--

local function approach_zero(v, amount)
    if v > 0 then return math.max(v - amount, 0) end
    return math.min(v + amount, 0)
end

-- shoves a train the leading end ran into. it gets at least this train's speed, so
-- it keeps rolling on its own once this train slows down
local function push(train)
    local which = train.speed > 0 and 1 or -1
    local hit = find_touching(train, which, -1, gap - 0.001)
    if not hit then return end
    local other = hit.train
    -- moving their touching end away from us
    local sign = -hit.which
    local speed = math.abs(train.speed)
    if other.speed * sign < speed then
        other.speed = speed * sign
    end
    local overlap = gap - hit.gap
    if not move(other, overlap * sign) then
        -- they're stuck, so are we
        other.speed = 0
        train.speed = 0
        move(train, -overlap * which)
    end
    update_objects(other)
end

local function step_train(train, dtime)
    train.respawn_timer = train.respawn_timer + dtime
    if train.respawn_timer >= 1 then
        train.respawn_timer = 0
        respawn_vehicles(train)
        if train.dirty then
            train.dirty = nil
            update_objects(train)
            refresh_end_chains(train)
        end
    end

    -- the first driver in an engine controls the train
    local controls, sign
    for _, v in ipairs(train.vehicles) do
        local ent = types[v.type].can_drive and valid(v.object) and v.object:get_luaentity()
        local player = ent and ent.rider and core.get_player_by_name(ent.rider)
        if player then
            controls, sign = player:get_player_control(), v.flip and -1 or 1
            break
        end
    end

    local powered = controls and not controls.jump and (controls.up or controls.down)
    local pull = gravity * train.slope * dtime
    if powered then
        pull = pull / math.max(train.engines, 1)
    end
    local speed = train.speed - pull
    if controls and controls.jump then
        speed = approach_zero(speed, brake_force * dtime)
    elseif controls and controls.up then
        speed = speed + sign * acceleration * dtime
    elseif controls and controls.down then
        speed = speed - sign * acceleration * dtime
    else
        speed = approach_zero(speed, friction * dtime)
    end
    speed = math.max(math.min(speed, max_speed), -max_speed)

    -- standing still, nothing to update
    if speed == 0 and train.speed == 0 then return end
    train.speed = speed

    if not move(train, speed * dtime) then
        train.speed = 0
    end
    if train.speed ~= 0 then
        push(train)
    end
    update_objects(train)

    -- looking for touching trains is the expensive part, so it isn't done every step
    train.touch_timer = train.touch_timer + dtime
    if train.touch_timer >= touch_interval or train.speed == 0 then
        train.touch_timer = 0
        refresh_end_chains(train)
    else
        move_end_chains(train)
    end
end

local function serialize_train(train)
    local vehicles = {}
    for i, v in ipairs(train.vehicles) do
        vehicles[i] = {type = v.type, flip = v.flip, owner = v.owner, car = v.car and fl_trains.serialize_car(v.car)}
    end
    return {path = train.path, head = train.head, speed = train.speed, vehicles = vehicles}
end

local function deserialize_train(data)
    local train = {path = data.path, head = data.head, speed = data.speed or 0, vehicles = {}}
    for _, seg in ipairs(train.path) do
        rail.restore(seg)
    end
    for i, v in ipairs(data.vehicles) do
        train.vehicles[i] = {
            type = v.type, flip = v.flip, owner = v.owner,
            car = v.type == "cart" and fl_trains.new_car(v.car) or nil,
        }
    end
    -- chains and the other vehicles are spawned on the first step
    train.dirty = true
    return new_train(train)
end

--
-- registration
--

--[[
    def:
    length: in nodes
    can_drive: whoever rides it controls the train
    entity: entity definition, the train callbacks are added to it
    item: craftitem definition, on_place is added to it
    place_head: distance along the clicked segment to place the vehicle center at
    legacy: function(data) converting older staticdata to train data, optional
    on_adopt: function(self) called when the entity gets its vehicle, optional
    can_remove: function(self, player) whether it can be picked up now, optional
    on_remove: function(self, player) giving back the vehicle when it is picked up
]]
function fl_trains.register_vehicle(type_name, def)
    local entity_name = "fl_trains:" .. type_name
    types[type_name] = {entity = entity_name, length = def.length, can_drive = def.can_drive, on_adopt = def.on_adopt}
    local entity = def.entity

    entity.on_activate = function(self, staticdata)
        local data = core.deserialize(staticdata) or {}
        self.object:set_armor_groups({immortal = 1})
        -- spawned by a train, which adopts it straight after
        if data.spawned then
            self.spawned = true
            self.object:set_properties({static_save = false})
            return
        end

        local train_data = data.train or (def.legacy and def.legacy(data))
        if not train_data then
            local seg = rail.find(vector.round(self.object:get_pos()), core.yaw_to_dir(self.object:get_yaw()))
            if not seg then return end
            train_data = {path = {seg}, head = def.place_head(seg), vehicles = {{type = type_name}}}
        end
        local train = deserialize_train(train_data)
        train.vehicles[1].object = self.object
        adopt(train, 1)
        local seg, d = locate(train, 0)
        rail.place_object(self.object, seg, d, train.speed, train.vehicles[1].flip)
    end

    entity.get_staticdata = function(self)
        local train = self.train
        if train and train.vehicles[1] == self.vehicle then
            return core.serialize({train = serialize_train(train)})
        end
        return ""
    end

    entity.on_deactivate = function(self)
        fl_trains.unseat(self.rider)
        self.rider = nil
        local train = self.train
        -- the leader takes the rest of the train with it, it was saved with it
        if train and not train.dead and train.vehicles[1] == self.vehicle then
            for i, v in ipairs(train.vehicles) do
                if i > 1 and valid(v.object) then
                    v.object:remove()
                end
                v.object = nil
                if v.car then
                    fl_trains.unload_car(v.car)
                end
            end
            kill(train)
        end
    end

    entity.on_step = function(self, dtime)
        -- never adopted, or the train is gone
        if self.spawned or (self.train and self.train.dead) then
            self.object:remove()
            return
        end
        if self.rider and not core.get_player_by_name(self.rider) then
            fl_trains.unseat(self.rider)
            self.rider = nil
        end
        if self.train and self.train.vehicles[1] == self.vehicle then
            step_train(self.train, dtime)
        end
    end

    -- sneak + punch picks it up, plain punches are too easy to land by accident
    entity.on_punch = function(self, puncher)
        local train = self.train
        if not (train and puncher and puncher:is_player()) then return end
        local name = puncher:get_player_name()
        if not puncher:get_player_control().sneak then
            core.chat_send_player(name, "sneak and punch to pick this up")
            return
        end
        if not fl_trains.can_access(puncher, self.vehicle.owner) then
            core.chat_send_player(name, "this belongs to " .. self.vehicle.owner)
            return
        end
        if def.can_remove and not def.can_remove(self, puncher) then return end

        local index = index_of(train, self.vehicle)
        if index then
            remove_vehicle(train, index)
        end
        self.train = nil
        fl_trains.unseat(self.rider)
        self.rider = nil
        def.on_remove(self, puncher)
        self.object:remove()
    end

    core.register_entity(entity_name, entity)

    def.item.on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then return end
        local player = placer and placer:is_player() and placer
        local name = player and player:get_player_name()
        if name and core.is_protected(pointed_thing.under, name) then
            core.record_protection_violation(pointed_thing.under, name)
            return
        end
        local dir = placer and placer:get_look_dir() or vector.new(0, 0, 1)
        local seg = rail.find(pointed_thing.under, dir)
        if not seg then return end

        local vehicle = {type = type_name, owner = name, car = type_name == "cart" and {} or nil}
        local train_data = {path = {seg}, head = def.place_head(seg), speed = 0, vehicles = {vehicle}}
        local obj = core.add_entity(rail.transform(seg, train_data.head), entity_name,
            core.serialize({train = train_data}))
        local ent = obj and obj:get_luaentity()
        if ent and ent.train then
            join_nearby(ent.train, 0.9, player)
        end

        if not (name and core.is_creative_enabled(name)) then
            itemstack:take_item()
        end
        return itemstack
    end
    core.register_craftitem(entity_name, def.item)
end

--
-- chain between vehicles, click it to join or split them
--

local chain_textures = {"farlands_chain_1.png", "farlands_chain_2.png"}
local loose_chain_textures = {"farlands_chain_1.png^[opacity:110", "farlands_chain_2.png^[opacity:110"}

local function chain_clicked(self, clicker)
    local train = self.train
    if not train or train.dead then return end

    -- the vehicles on both sides of the chain
    local a, b
    if self.coupled then
        a, b = train.vehicles[self.index], train.vehicles[self.index + 1]
    elseif self.other and not self.other.dead then
        a, b = end_vehicle(train, self.which), end_vehicle(self.other, self.other_which)
    end
    if not (a and b) then return end
    if clicker and clicker:is_player()
        and not (fl_trains.can_access(clicker, a.owner) and fl_trains.can_access(clicker, b.owner))
    then
        core.chat_send_player(clicker:get_player_name(), "you can only join or split your own vehicles")
        return
    end

    if self.coupled then
        fl_trains.split(train, self.index + 1)
    else
        fl_trains.join(train, self.which, self.other, self.other_which, 0.3)
    end
end

core.register_entity("fl_trains:chain", {
    initial_properties = {
        physical = false,
        collisionbox = {0, 0, 0, 0, 0, 0},
        selectionbox = {-0.1, -0.1, -0.2, 0.1, 0.1, 0.2, rotate = true},
        visual = "mesh",
        mesh = "farlands_coupler.obj",
        textures = chain_textures,
        use_texture_alpha = true,
        backface_culling = false,
        visual_size = {x=10, y=10, z=10},
        static_save = false,
    },

    on_activate = function(self)
        self.object:set_armor_groups({immortal = 1})
        self.timer = 0
    end,

    -- coupled chains are solid, chains between touching trains are faded
    set_kind = function(self, coupled)
        if self.coupled == coupled then return end
        self.coupled = coupled
        if coupled then
            self.other, self.which, self.other_which = nil, nil, nil
        else
            self.index = nil
        end
        self.object:set_properties({textures = coupled and chain_textures or loose_chain_textures})
    end,

    on_step = function(self, dtime)
        local train = self.train
        if not train or train.dead then
            self.object:remove()
            return
        end
        if self.coupled then
            if train.chains[self.index] ~= self.object then
                self.object:remove()
            end
            return
        end

        -- the trains may have moved apart while the one showing the chain stood still
        self.timer = self.timer + dtime
        if self.timer < 0.5 then return end
        self.timer = 0
        local touching = train.end_chains[self.which] == self.object
            and find_touching(train, self.which, gap - 0.06, gap + 0.06)
        if not (touching and touching.train == self.other) then
            if train.end_chains[self.which] == self.object then
                train.end_chains[self.which] = nil
            end
            self.object:remove()
        end
    end,

    on_punch = function(self, puncher)
        chain_clicked(self, puncher)
    end,

    on_rightclick = function(self, clicker)
        chain_clicked(self, clicker)
    end,
})
