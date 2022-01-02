minetest.register_entity("fl_plantlife:flowerpot_ent", {
    initial_properties = {
        visual = "mesh",
        mesh = "farlands_plant3.obj",
        textures = {"[combine:16x16", "[combine:16x16"},
        static_save = true,
        backface_culling = false,
        shaded = false,
        visual_size = {x=10,y=10,z=10},
        collisionbox = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
    },

    get_staticdata = function(self)
        local tmp = {memory = self.memory}
        return minetest.serialize(tmp)
    end,
    on_activate = function(self, staticdata, dtime_s)
        local sdata = minetest.deserialize(staticdata)
        if sdata then
            for k,v in pairs(sdata) do
                self[k] = v
            end
        end
        if not self.memory then self.memory = {} end
        if self.memory.textures then self.object:set_properties({textures = self.memory.textures}) end
        self.name = "fl_plantlife:flower_ent"
    end,

    on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
        --minetest.chat_send_all("punch")
        if not self.memory.item_name then return end
        minetest.add_item(self.object:get_pos(), ItemStack(self.memory.item_name))
        self.memory.item_name = nil
        self.memory.textures = {"[combine:16x16", "[combine:16x16"}
        --self.memory.textures = {"farlands_flower_dandelion_yellow.png", "farlands_flower_dandelion_yellow.png"}
        self.object:set_properties({textures = self.memory.textures})
    end,
    on_rightclick = function(self, clicker)
        --minetest.chat_send_all("rightclick")
        --self.memory.textures = {"farlands_flower_dandelion_white.png", "farlands_flower_dandelion_white.png"}
        --self.object:set_properties({textures = self.memory.textures})
        local stack = clicker:get_wielded_item()
        if minetest.get_item_group(stack:get_name(), "potable") ~= 1 then return end
        if self.memory.item_name then minetest.add_item(self.object:get_pos(), ItemStack(self.memory.item_name)) end
        self.memory.item_name = stack:get_name()
        local node_def = minetest.registered_nodes[stack:get_name()]
        self.memory.textures = {node_def.tiles[1] .. "^[transformR180", node_def.tiles[1] .. "^[transformR180"}
        self.object:set_properties({textures = self.memory.textures})
    end,
})

local box = {type = "fixed", fixed = {-0.2, -0.5, -0.2, 0.2, -0.1, 0.2}}

minetest.register_node("fl_plantlife:flowerpot", {
    description = "flowerpot",
    paramtype = "light",
    use_texture_alpha = "clip",
    drawtype = "mesh",
    visual_scale = 0.5,
    mesh = "farlands_flowerpot.obj",
    tiles = {"farlands_pot.png"},
    selection_box = box,
    collision_box = box,
    on_construct = function(pos)
        minetest.add_entity({x=pos.x, y=pos.y+0.3, z=pos.z}, "fl_plantlife:flowerpot_ent")
    end,
    on_destruct = function(pos)
        local obj = minetest.get_objects_inside_radius(pos, 0.5)
        for _, objref in pairs(obj) do
            local ent = objref:get_luaentity()
            if objref and ent and ent.name == "fl_plantlife:flower_ent" then
                if ent.memory.item_name then minetest.add_item(objref:get_pos(), ItemStack(ent.memory.item_name)) end
                objref:remove() break
            end
        end
    end,
    groups = {oddly_breakable_by_hand = 3}
})