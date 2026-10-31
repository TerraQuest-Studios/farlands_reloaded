-- following the track. a segment is the path through one node:
--   pos: the node
--   from, to: ports it enters and leaves through, `to` is the way it faces
--   hfrom, hto: height of those ports (rises)

local ports = fl_trains.ports
local get_exit = fl_trains.get_exit
local get_port_height = fl_trains.get_port_height
-- segments used to approximate each path through a node
local samples = 8

local rail = {}
fl_trains.rail = rail

-- path between two ports relative to the node center. it is a quadratic bezier with
-- the control point at the center, so opposite ports give a straight line and
-- 45 degree turns give a curve that follows the curved meshes
local path_cache = {}
local function get_path(seg)
    local key = seg.from + seg.to * 8 + seg.hfrom * 64 + seg.hto * 128
    local path = path_cache[key]
    if path then return path end

    local a, b = ports[seg.from] * 0.5, ports[seg.to] * 0.5
    local points, dists = {}, {0}
    for i = 0, samples do
        local t = i / samples
        local p = a * (1 - t) ^ 2 + b * t ^ 2
        p.y = seg.hfrom + (seg.hto - seg.hfrom) * t
        points[i + 1] = p
        if i > 0 then
            dists[i + 1] = dists[i] + vector.distance(points[i], p)
        end
    end
    path = {points = points, dists = dists, length = dists[samples + 1]}
    path_cache[key] = path
    return path
end

function rail.length(seg)
    return get_path(seg).length
end

-- world position and facing direction at dist along a segment
function rail.transform(seg, dist)
    local path = get_path(seg)
    local dists, points = path.dists, path.points
    local i = 1
    while i < samples and dists[i + 1] < dist do
        i = i + 1
    end
    local a, b = points[i], points[i + 1]
    local f = math.min(math.max((dist - dists[i]) / (dists[i + 1] - dists[i]), 0), 1)
    return seg.pos + a + (b - a) * f, vector.normalize(b - a)
end

function rail.reversed(seg)
    return {pos = seg.pos, from = seg.to, to = seg.from, hfrom = seg.hto, hto = seg.hfrom}
end

-- segment entering the node at pos through the port entry, nil if there is no track
local function enter(pos, entry)
    local node = core.get_node_or_nil(pos)
    local exit = node and get_exit(node, entry)
    if not exit then return end
    return {
        pos = pos, from = entry, to = exit,
        hfrom = get_port_height(node, entry), hto = get_port_height(node, exit),
    }
end

-- segment after seg, nil at the end of the track
function rail.next(seg)
    local entry = (seg.to + 4) % 8
    local pos = seg.pos + ports[seg.to]
    pos.y = pos.y + seg.hto
    local nxt = enter(pos, entry)
    if nxt and nxt.hfrom == 0 then return nxt end
    -- going down a rise
    nxt = enter(pos:offset(0, -1, 0), entry)
    if nxt and nxt.hfrom == 1 then return nxt end
end

-- segment before seg, nil at the end of the track
function rail.prev(seg)
    local prev = rail.next(rail.reversed(seg))
    return prev and rail.reversed(prev)
end

-- segment through the node at pos facing as close to dir as the track allows
function rail.find(pos, dir)
    local node = core.get_node_or_nil(pos)
    if not node then return end
    local best, best_dot
    for entry = 0, 7 do
        local exit = get_exit(node, entry)
        if exit then
            local d = vector.dot(vector.normalize(ports[exit] - ports[entry]), dir)
            if not best or d > best_dot then
                best, best_dot = entry, d
            end
        end
    end
    return best and enter(vector.copy(pos), best)
end

-- segments loaded from staticdata lose their vector metatable
function rail.restore(seg)
    seg.pos = vector.copy(seg.pos)
    return seg
end

-- moves an object to pos facing along dir (against it with flip). set_pos sends every
-- call to clients unsmoothed, move_to leaves it to the engine to send updates when
-- the object strays from where the velocity lets clients predict it
function rail.set_transform(obj, pos, dir, speed, flip)
    obj:move_to(pos, true)
    obj:set_velocity(dir * speed)
    obj:set_rotation(vector.dir_to_rotation(flip and -dir or dir))
end

function rail.place_object(obj, seg, dist, speed, flip)
    local pos, dir = rail.transform(seg, dist)
    rail.set_transform(obj, pos, dir, speed, flip)
end
