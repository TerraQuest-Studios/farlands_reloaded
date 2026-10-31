local seat_pos = vector.new(0,-0.46,0.45)
local eye_offset = vector.new(0,-13,5.5)

fl_trains.register_vehicle("train_engine", {
    length = 2,
    can_drive = true,
    -- two nodes long, it covers the clicked node and the one behind it
    place_head = function()
        return 0
    end,
    -- engines saved before trains could have carts on either side
    legacy = function(data)
        if not data.path then return end
        local vehicles = {{type = "train_engine"}}
        for _, car in ipairs(data.cars or {}) do
            vehicles[#vehicles + 1] = {type = "cart", car = car}
        end
        return {path = data.path, head = data.head, speed = data.speed, vehicles = vehicles}
    end,
    on_remove = function(_, puncher)
        if not (puncher and puncher:is_player()) then return end
        local inv = puncher:get_inventory()
        if core.is_creative_enabled(puncher:get_player_name())
            and inv:contains_item("main", "fl_trains:train_engine")
        then return end

        inv:add_item("main", "fl_trains:train_engine")
    end,

    entity = {
        initial_properties = {
            -- movement is driven by the track, not physics
            physical = false,
            collisionbox = {-0.5, -0.47, -0.5, 0.5, 0.53, 0.5},
            selectionbox = {-0.5, -0.47, -1, 0.5, 0.53, 1, rotate = true},
            visual = "mesh",
            mesh = "farlands_train_engine.obj",
            textures = {
                "farlands_train_engine.png",
            },
            backface_culling = false,
            visual_size = {x=10, y=10, z=10},
            static_save = true,
            damage_texture_modifier = "^[colorize:#FF000040"
        },

        on_rightclick = function(self, clicker)
            if not (clicker and clicker:is_player()) then return end
            local name = clicker:get_player_name()
            if not (self.vehicle and fl_trains.can_access(clicker, self.vehicle.owner)) then
                local owner = self.vehicle and self.vehicle.owner or "someone"
                core.chat_send_player(name, "this engine belongs to " .. owner)
                return
            end
            if self.rider == name then
                fl_trains.unseat(name)
                self.rider = nil
            elseif not self.rider then
                fl_trains.seat(clicker, self.object, seat_pos, eye_offset, "third")
                self.rider = name
            end
        end,
    },

    item = {
        description = "train_engine",
        inventory_image = "farlands_cart_item.png",
        wield_image = "farlands_cart_item.png",
        groups = {not_in_creative_inventory = 1},
    },
})
