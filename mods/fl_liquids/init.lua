local modpath = minetest.get_modpath("fl_liquids")
local water_inventory_image =
"[inventorycube{farlands_water_source_animated.png&[verticalframe:16:8"
.. "{farlands_water_source_animated.png&[verticalframe:16:8"
.. "{farlands_water_source_animated.png&[verticalframe:16:8"
local river_water_inventory_image =
"[inventorycube{farlands_river_water_source_animated.png&[verticalframe:16:8"
.. "{farlands_river_water_source_animated.png&[verticalframe:16:8"
.. "{farlands_river_water_source_animated.png&[verticalframe:16:8"

dofile(modpath .. "/buckets.lua")

local function bucket_func(itemstack, user, pos, bucket, liquid)
    if user:get_wielded_item():get_count() > 1 then
        local inv = user:get_inventory()
        if inv:room_for_item("main", {name=bucket}) then inv:add_item("main", bucket)
        else
            local ppos = user:get_pos()
            ppos.y = math.floor(pos.y + 0.5)
            minetest.add_item(ppos, bucket)
        end
        local renew = minetest.find_node_near(pos, 1, liquid)
        if not renew then minetest.add_node(pos, {name = "air"}) end
        itemstack:take_item()
        return itemstack
    end

        local renew = minetest.find_node_near(pos, 1, liquid)
        if not renew then minetest.add_node(pos, {name = "air"}) end
        return ItemStack(bucket)
end

minetest.register_node("fl_liquids:water_source", {
	description = "Water Source",
	drawtype = "liquid",
	waving = 3,
	tiles = {
		{
			name = "farlands_water_source_animated.png^[opacity:103",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "farlands_water_source_animated.png^[opacity:103",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
    --below 2 are hacks to deal with alpha being set above
    inventory_image = water_inventory_image,
    wield_image = "farlands_water_source_animated.png^[verticalframe:16:8",
	use_texture_alpha = "blend",
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "fl_liquids:water_flowing",
	liquid_alternative_source = "fl_liquids:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, cools_lava = 1},
    _bottle_item = "fl_bottles:water",
    _bucket = function(itemstack, user, pos)
        return bucket_func(itemstack, user, pos, "fl_bucket:bucket_water", "fl_liquids:water_source")
    end,
})

minetest.register_node("fl_liquids:water_flowing", {
	description = "Flowing Water",
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {"farlands_water.png"},
	special_tiles = {
		{
			name = "farlands_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.5,
			},
		},
		{
			name = "farlands_water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.5,
			},
		},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "fl_liquids:water_flowing",
	liquid_alternative_source = "fl_liquids:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, not_in_creative_inventory = 1, cools_lava = 1},
})


minetest.register_node("fl_liquids:river_water_source", {
	description = "River Water Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "farlands_river_water_source_animated.png^[opacity:103",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "farlands_river_water_source_animated.png^[opacity:103",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
    --below 2 are hacks to deal with alpha being set above
    inventory_image = river_water_inventory_image,
    wield_image = "farlands_river_water_source_animated.png^[verticalframe:16:8",
	use_texture_alpha = "blend",
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "fl_liquids:river_water_flowing",
	liquid_alternative_source = "fl_liquids:river_water_source",
	liquid_viscosity = 1,
	liquid_renewable = false,
	liquid_range = 2,
	post_effect_color = {a = 103, r = 30, g = 76, b = 90},
	groups = {water = 3, liquid = 3, cools_lava = 1},
    _bottle_item = "fl_bottles:river_water",
    _bucket = function(itemstack, user, pos)
        return bucket_func(itemstack, user, pos, "fl_bucket:bucket_river_water", "fl_liquids:river_water_source")
    end,
})

minetest.register_node("fl_liquids:river_water_flowing", {
	description = "Flowing River Water",
	drawtype = "flowingliquid",
	tiles = {"farlands_river_water.png"},
	special_tiles = {
		{
			name = "farlands_river_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.5,
			},
		},
		{
			name = "farlands_river_water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.5,
			},
		},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "fl_liquids:river_water_flowing",
	liquid_alternative_source = "fl_liquids:river_water_source",
	liquid_viscosity = 1,
	liquid_renewable = false,
	liquid_range = 2,
	post_effect_color = {a = 103, r = 30, g = 76, b = 90},
	groups = {water = 3, liquid = 3, not_in_creative_inventory = 1, cools_lava = 1},
})

minetest.register_node("fl_liquids:lava_source", {
	description = "Lava Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "farlands_lava_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
		{
			name = "farlands_lava_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
	},
	paramtype = "light",
	light_source = 14,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	--drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "fl_liquids:lava_flowing",
	liquid_alternative_source = "fl_liquids:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 3, liquid = 2, igniter = 1},
    _bucket = function(itemstack, user, pos)
        return bucket_func(itemstack, user, pos, "fl_bucket:bucket_lava", "fl_liquids:lava_source")
    end,
})

minetest.register_node("fl_liquids:lava_flowing", {
	description = "Flowing Lava",
	drawtype = "flowingliquid",
	tiles = {"farlands_lava.png"},
	special_tiles = {
		{
			name = "farlands_lava_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
		{
			name = "farlands_lava_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = 14,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	--drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "fl_liquids:lava_flowing",
	liquid_alternative_source = "fl_liquids:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 3, liquid = 2, igniter = 1, not_in_creative_inventory = 1},
})

minetest.register_alias("fl_terrain:water_source", "fl_liquids:water_source")
minetest.register_alias("fl_terrain:water_flowing", "fl_liquids:water_flowing")
minetest.register_alias("fl_terrain:river_water_source", "fl_liquids:river_water_source")
minetest.register_alias("fl_terrain:river_water_flowing", "fl_liquids:river_water_flowing")
minetest.register_alias("fl_terrain:lava_source", "fl_liquids:lava_source")
minetest.register_alias("fl_terrain:lava_flowing", "fl_liquids:lava_flowing")