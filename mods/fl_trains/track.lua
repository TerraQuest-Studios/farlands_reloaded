-- ports are the 8 points a track can connect through, clockwise from north:
-- edge midpoints for N/E/S/W, node corners for the diagonals
local N, NE, E, SE, S, SW, W, NW = 0, 1, 2, 3, 4, 5, 6, 7

fl_trains.ports = {
    [N] = vector.new(0, 0, 1), [NE] = vector.new(1, 0, 1),
    [E] = vector.new(1, 0, 0), [SE] = vector.new(1, 0, -1),
    [S] = vector.new(0, 0, -1), [SW] = vector.new(-1, 0, -1),
    [W] = vector.new(-1, 0, 0), [NW] = vector.new(-1, 0, 1),
}

-- connections are for param2 = 0, in world space (the meshes are mirrored on x on load)
-- routes: pairs of ports joined by rail
-- trunk/branches: switches, entering from the trunk exits through the selected branch
-- high: port that is one node higher than the other end
-- forward: direction (as a port) that faces away from the player when placed,
--   defaults to away from the trunk for switches and the first port of the first route otherwise
local tracks = {
    straight = {description = "straight track", mesh = "farlands_straight.obj", rail_first = true,
        routes = {{N, S}}},
    straight_rise = {description = "straight rise track", mesh = "farlands_straight_rise.obj", rail_first = true,
        routes = {{N, S}}, high = S, forward = S},
    straight_45 = {description = "45 degree straight track", mesh = "farlands_straight_45.obj",
        routes = {{NE, SW}}},
    curve_left = {description = "left curve track", mesh = "farlands_curved_left.obj",
        routes = {{N, SE}}, forward = S},
    curve_right = {description = "right curve track", mesh = "farlands_curved_right.obj",
        routes = {{N, SW}}, forward = S},
    skewed = {description = "skewed track", mesh = "farlands_skewed.obj",
        routes = {{N, S}, {NE, SW}}},
    crossing = {description = "crossing track", mesh = "farlands_crossing.obj",
        routes = {{N, S}, {E, W}}},
    crossing_45 = {description = "45 degree crossing track", mesh = "farlands_crossing_45.obj",
        routes = {{NE, SW}, {NW, SE}}},
    ["6_way"] = {description = "6 way track", mesh = "farlands_6_way.obj",
        routes = {{N, S}, {NE, SW}, {NW, SE}}},
    ["6_way_45"] = {description = "45 degree 6 way track", mesh = "farlands_6_way_45.obj",
        routes = {{N, S}, {E, W}, {NE, SW}}},
    ["8_way"] = {description = "8 way track", mesh = "farlands_8_way.obj",
        routes = {{N, S}, {E, W}, {NE, SW}, {NW, SE}}},
    switch_left = {description = "switch left track", mesh = "farlands_switch_left.obj",
        trunk = N, branches = {S, SE}},
    switch_right = {description = "switch right track", mesh = "farlands_switch_right.obj",
        trunk = N, branches = {S, SW}},
    switch_left_45 = {description = "45 degree switch left track", mesh = "farlands_switch_left_45.obj",
        trunk = SW, branches = {NE, N}},
    switch_right_45 = {description = "45 degree switch right track", mesh = "farlands_switch_right_45.obj",
        trunk = SW, branches = {NE, E}},
    switch_y = {description = "y switch track", mesh = "farlands_switch_y.obj",
        trunk = N, branches = {SE, SW}},
    switch_y_45 = {description = "45 degree y switch track", mesh = "farlands_switch_y_45.obj",
        trunk = NE, branches = {S, W}},
    switch_psi = {description = "psi switch track", mesh = "farlands_switch_psi.obj",
        trunk = N, branches = {SE, S, SW}},
    switch_psi_45 = {description = "45 degree psi switch track", mesh = "farlands_switch_psi_45.obj",
        trunk = NE, branches = {S, SW, W}},
}

-- node name -> {links = {[port] = port}, trunk, branches, high}
fl_trains.tracks = {}

-- the switch state lives in the upper bits of param2, 4dir only uses param2 % 4
local function get_switch_state(def, param2)
    return math.floor(param2 / 4) % #def.branches
end

-- port that a train entering through `entry` (world space) leaves through, or nil
function fl_trains.get_exit(node, entry)
    local def = fl_trains.tracks[node.name]
    if not def then return end
    local rot = 2 * (node.param2 % 4)
    local port = (entry - rot) % 8
    local exit
    if def.branches and port == def.trunk then
        exit = def.branches[get_switch_state(def, node.param2) + 1]
    else
        exit = def.links[port]
    end
    return exit and (exit + rot) % 8
end

-- height of a port (world space) relative to the node, 0 or 1
function fl_trains.get_port_height(node, port)
    local def = fl_trains.tracks[node.name]
    if def and def.high and (def.high + 2 * (node.param2 % 4)) % 8 == port then
        return 1
    end
    return 0
end

local function turn_name(trunk, branch)
    local diff = (branch - (trunk + 4)) % 8
    if diff == 0 then return "straight" end
    return diff < 4 and "right" or "left"
end

local function switch_rightclick(pos, node, clicker)
    if clicker and clicker:is_player() and core.is_protected(pos, clicker:get_player_name()) then
        core.record_protection_violation(pos, clicker:get_player_name())
        return
    end
    local def = fl_trains.tracks[node.name]
    local state = (get_switch_state(def, node.param2) + 1) % #def.branches
    node.param2 = node.param2 % 4 + state * 4
    core.swap_node(pos, node)
    if clicker and clicker:is_player() then
        core.chat_send_player(clicker:get_player_name(),
            "switch set to " .. turn_name(def.trunk, def.branches[state + 1]))
    end
end

-- picks the rotation that points the forward port closest to where the placer is looking.
-- uses the exact view angle so diagonal pieces follow a diagonal look direction,
-- core.dir_to_fourdir only knows N/E/S/W
local function place_track(itemstack, placer, pointed_thing, forward)
    local param2
    if placer and placer:is_player() then
        -- yaw is counterclockwise from north, ports are clockwise in 45 degree steps
        local look = -placer:get_look_horizontal() / (math.pi / 4)
        param2 = math.floor((look - forward) / 2 + 0.5) % 4
    end
    return core.item_place(itemstack, placer, pointed_thing, param2)
end

for name, def in pairs(tracks) do
    local nodename = "fl_trains:" .. name .. "_track"
    local forward = def.forward or (def.trunk and (def.trunk + 4) % 8) or def.routes[1][1]
    local links = {}
    for _, route in ipairs(def.routes or {}) do
        links[route[1]] = route[2]
        links[route[2]] = route[1]
    end
    for _, branch in ipairs(def.branches or {}) do
        links[branch] = def.trunk
    end
    fl_trains.tracks[nodename] = {links = links, trunk = def.trunk, branches = def.branches, high = def.high}

    core.register_node(nodename, {
        description = def.description,
        paramtype = "light",
        paramtype2 = "4dir",
        drawtype = "mesh",
        mesh = def.mesh,
        -- tiles follow the order of the objects in the mesh
        tiles = def.rail_first and {"farlands_rail.png", "farlands_ties.png"}
            or {"farlands_ties.png", "farlands_rail.png"},
        groups = {oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
        selection_box = {
            type = "fixed",
            fixed = {-0.5,-0.5,-0.5,0.5,-0.475,0.5},
        },
        collision_box = {
            type = "fixed",
            fixed = {0,0,0,0,0,0},
        },
        on_rightclick = def.branches and switch_rightclick or nil,
        on_place = function(itemstack, placer, pointed_thing)
            return place_track(itemstack, placer, pointed_thing, forward)
        end,
    })
end
