local rail = fl_trains.rail

local seat_pos = vector.new(0, -0.42, 0)
local eye_offset = vector.new(0, -13, 0)
local has_chests = core.get_modpath("fl_storage") ~= nil

local function update_visual(self)
    if self.vehicle.car.kind == "chest" then
        self.object:set_properties({
            mesh = "farlands_cart_chest.obj",
            textures = {
                "farlands_cart.png", "farlands_chest_top.png", "farlands_chest_side.png", "farlands_chest_front.png",
            },
        })
    else
        self.object:set_properties({mesh = "farlands_cart.obj", textures = {"farlands_cart.png"}})
    end
end

fl_trains.register_vehicle("cart", {
    length = 1,
    place_head = function(seg)
        return rail.length(seg) / 2
    end,
    -- carts saved before trains existed
    legacy = function(data)
        if data.rail then
            return {path = {data.rail.seg}, head = data.rail.dist, vehicles = {{type = "cart", car = data.car}}}
        end
    end,
    on_adopt = update_visual,
    can_remove = function(self, player)
        local car = self.vehicle.car
        if car.inv and not core.get_inventory({type = "detached", name = car.inv}):is_empty("main") then
            core.chat_send_player(player:get_player_name(), "empty the chest first")
            return false
        end
        return true
    end,
    on_remove = function(self, puncher)
        fl_trains.give_car(self.vehicle.car, puncher, self.object:get_pos())
    end,

    entity = {
        initial_properties = {
            -- movement is driven by the track, not physics
            physical = false,
            collisionbox = {-0.5, -0.47, -0.5, 0.5, 0.03, 0.5},
            selectionbox = {-0.5, -0.47, -0.5, 0.5, 0.03, 0.5, rotate = true},
            visual = "mesh",
            mesh = "farlands_cart.obj",
            textures = {
                "farlands_cart.png",
            },
            backface_culling = false,
            visual_size = {x=10, y=10, z=10},
            static_save = true,
            damage_texture_modifier = "^[colorize:#FF000040"
        },

        on_rightclick = function(self, clicker)
            if not (self.vehicle and clicker and clicker:is_player()) then return end
            local car = self.vehicle.car

            if car.kind == "chest" then
                if not fl_trains.can_access(clicker, self.vehicle.owner) then
                    core.chat_send_player(clicker:get_player_name(), "this chest belongs to " .. self.vehicle.owner)
                    return
                end
                fl_storage.show_chest_formspec(clicker, "detached:" .. car.inv, "cart")
                return
            end

            local wielded = clicker:get_wielded_item()
            if has_chests and wielded:get_name() == "fl_storage:wood_chest" and not self.rider then
                car.kind = "chest"
                car.inv = fl_trains.new_car({kind = "chest"}).inv
                update_visual(self)
                if not core.is_creative_enabled(clicker:get_player_name()) then
                    wielded:take_item()
                    clicker:set_wielded_item(wielded)
                end
                return
            end

            local name = clicker:get_player_name()
            if self.rider == name then
                fl_trains.unseat(name)
                self.rider = nil
            elseif not self.rider then
                fl_trains.seat(clicker, self.object, seat_pos, eye_offset)
                self.rider = name
            end
        end,
    },

    item = {
        description = "cart",
        inventory_image = "farlands_cart_item.png",
        wield_image = "farlands_cart_item.png",
        groups = {not_in_creative_inventory = 1},
    },
})
