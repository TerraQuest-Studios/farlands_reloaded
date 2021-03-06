minetest.register_craftitem("fl_wildlife:nametag", {
    description = "Name Tag",
    inventory_image = "farlands_nametag.png",
    --groups = {flammable = 2, nametag = 1},
})

minetest.register_entity("fl_wildlife:chicken_egg_entity", {
    initial_properties = {
        physical = true,
        --stepheight = 0.4,
        collide_with_objects = true,
        pointable = false,
        collisionbox = {-0.01, -0.01, -0.01, 0.01, 0.01, 0.01},
        visual = "wielditem",
        textures = {"fl_wildlife:chicken_egg"},
        visual_size = {x=0.2, y=0.2},
        static_save = true,
        --damage_texture_modifier = "^[colorize:#FF000040"
    },

    --[[
    on_activate = function(self, staticdata, dtime_s)
        local test = 1
    end,
    --]]
    on_step = function(self, dtime, moveresult)
        if not self.active_time then self.active_time = 0 end
        self.active_time = self.active_time + dtime
        if self.active_time >= 10 then
            self.object:remove() --edge case prevention
        end

        if moveresult.collides then
            local pos = vector.new(0,0,0)
            if moveresult.collisions[1].type == "node" then
                pos = moveresult.collisions[1].node_pos
            elseif moveresult.collisions[1].type == "object" then
                pos = moveresult.collisions[1].object:get_pos()
            end
            local vec = vector.normalize(moveresult.collisions[1].old_velocity)
            minetest.add_entity(vector.add(pos, vector.multiply(vec, -1)), "fl_wildlife:chicken")
            self.object:remove()
        end
    end,

})

minetest.register_craftitem("fl_wildlife:chicken_egg", {
    description = "chicken egg",
    inventory_image = "farlands_chicken_egg.png",
    on_use = function(itemstack, user, pointed_thing)
        --minetest.chat_send_all("used")
        if pointed_thing.type ~= "node" then return end

        --note that this spawning location calculation is terrible and only works sometimes
        local pt_pos = pointed_thing.under
        pt_pos.y = pt_pos.y + 0.5
        local p_pos = user:get_pos()
        p_pos.y = p_pos.y + 1.5
        --minetest.chat_send_all("player_pos: " .. minetest.pos_to_string(p_pos, 1))
        --minetest.chat_send_all("pointed_thing_pos: " .. minetest.pos_to_string(pt_pos, 1))
        local obj = minetest.add_entity(p_pos, "fl_wildlife:chicken_egg_entity")
        obj:set_velocity(vector.subtract(pt_pos, p_pos))
        obj:set_acceleration(vector.subtract(pt_pos, p_pos))
        --[[
        pt_pos.y = pt_pos.y + 1

        if minetest.get_node(pt_pos).name ~= "air" then return end

        if math.random(100) > 50 then
            minetest.add_entity(pt_pos, "fl_wildlife:chicken")
        end
        --]]
        if not minetest.settings:get_bool("creative_mode") then
            itemstack:take_item(1)
        end
        return itemstack
    end,
    groups = {not_in_creative_inventory = 1},
})

minetest.register_craftitem("fl_wildlife:leather", {
    description = "leather",
    inventory_image = "farlands_leather.png",
})

minetest.register_craftitem(":fl_bucket:milk", {
    description = "milk bucket",
    stack_max = 1,
    inventory_image = "farlands_bucket_milk.png",
    groups = {bucket = 1},
})

minetest.register_craftitem("fl_wildlife:raw_riverfish", {
    description = "raw riverfish",
    inventory_image = "farlands_raw_riverfish.png",
})

minetest.register_craftitem("fl_wildlife:cooked_riverfish", {
    description = "cooked riverfish",
    inventory_image = "farlands_cooked_riverfish.png",
    on_use = minetest.item_eat(5),
})

minetest.register_craftitem(":fl_bucket:riverfish", {
    description = "bucket of riverfish",
    inventory_image = "(farlands_bucket_water.png^[noalpha)^[brighten",
    on_place = function(itemstack, user, pointed_thing)
        local pos

        if pointed_thing.type == "node" then
            local node = minetest.get_node_or_nil(pointed_thing.under)
            local def = node and minetest.registered_nodes[node.name]

            if not user:get_player_control().sneak and def and def.on_rightclick then
                return def.on_rightclick(pointed_thing.under, node, user, itemstack)
            end

            if def and def.buildable_to then pos = pointed_thing.under
            else
                pos = pointed_thing.above
                local anode = minetest.get_node_or_nil(pos)
                if not minetest.registered_nodes[anode.name]
                or not minetest.registered_nodes[anode.name].buildable_to then
                    return itemstack
                end
            end
        elseif pointed_thing.type == "object" then
            pos = pointed_thing.ref:get_pos()
        else return end

        minetest.add_entity(pos, "fl_wildlife:riverfish")
        minetest.set_node(pos, {name = "fl_liquids:water_source"})
        return ItemStack("fl_bucket:bucket")
    end,
})