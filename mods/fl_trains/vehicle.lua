-- shared bits for the engine and carts: seats and cart inventories

-- whether player may pick up, drive or open a vehicle owned by owner
function fl_trains.can_access(player, owner)
    if not owner or owner == "" then return true end
    local name = player:get_player_name()
    return name == owner or core.check_player_privs(name, "protection_bypass")
end

-- attach offsets are scaled by the vehicle's visual_size, so they are in nodes.
-- camera_mode locks the player's camera ("first", "third", ...) until they get out
function fl_trains.seat(player, object, pos, eye_offset, camera_mode)
    player:set_attach(object, "", pos, vector.new(0,0,0), true)
    if camera_mode then
        player:set_camera({mode = camera_mode})
    end
    player:set_properties({visual_size = vector.new(.075,.075,.075)})
    fl_player.ignore[player:get_player_name()] = true
    player:set_animation(fl_player.animations["sit"], 15)
    player:set_eye_offset(eye_offset, eye_offset)
end

function fl_trains.unseat(name)
    if not name then return end
    fl_player.ignore[name] = nil
    local player = core.get_player_by_name(name)
    if not player then return end
    player:set_detach()
    -- "any" keeps the current view, so go back to first person before unlocking
    player:set_camera({mode = "first"})
    core.after(0.1, function()
        local p = core.get_player_by_name(name)
        if p and not p:get_attach() then
            p:set_camera({mode = "any"})
        end
    end)
    player:set_properties({visual_size = vector.new(1,1,1)})
    player:set_eye_offset(vector.new(0,0,0), vector.new(0,0,0))
end

--[[
    a car is the cargo of one cart, kept in its train's vehicle list (see train.lua):
    kind: nil for a seat, "chest" for a chest
    inv: detached inventory name of a chest
    items: chest contents, used to save the inventory once it is gone
]]

-- detached inventory names only need to be unique while the server runs
local inv_count = 0

function fl_trains.new_car(data)
    local car = {kind = data and data.kind}
    if car.kind == "chest" then
        inv_count = inv_count + 1
        car.inv = "fl_trains:cart_" .. inv_count
        local inv = core.create_detached_inventory(car.inv, {})
        inv:set_size("main", 9*4)
        inv:set_list("main", data.items or {})
    end
    return car
end

local function get_items(car)
    if not car.inv then return car.items end
    local items = {}
    for i, stack in ipairs(core.get_inventory({type = "detached", name = car.inv}):get_list("main")) do
        items[i] = stack:to_string()
    end
    return items
end

function fl_trains.serialize_car(car)
    return {kind = car.kind, items = get_items(car)}
end

-- frees the car's inventory, keeping its contents for serialize_car
function fl_trains.unload_car(car)
    if not car.inv then return end
    car.items = get_items(car)
    core.remove_detached_inventory(car.inv)
    car.inv = nil
end

-- gives the car and what it carries to player, dropping what doesn't fit at pos
function fl_trains.give_car(car, player, pos)
    local stacks = {ItemStack("fl_trains:cart")}
    if car.kind == "chest" then
        stacks[2] = ItemStack("fl_storage:wood_chest")
        for _, item in ipairs(get_items(car) or {}) do
            stacks[#stacks + 1] = ItemStack(item)
        end
    end
    fl_trains.unload_car(car)

    local inv = player and player:is_player() and player:get_inventory()
    local creative = inv and core.is_creative_enabled(player:get_player_name())
    for i, stack in ipairs(stacks) do
        -- creative players keep their cart and chest items, but not the contents
        if not (creative and i <= 2 and inv:contains_item("main", stack:get_name())) then
            local leftover = inv and inv:add_item("main", stack) or stack
            if not leftover:is_empty() then
                core.add_item(pos, leftover)
            end
        end
    end
end
