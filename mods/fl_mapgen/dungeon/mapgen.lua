--sfan5 MIT
core.set_gen_notify({dungeon = true, temple = true})

dungeon_loot.biomes = {}

for name, _ in pairs(core.registered_biomes) do
	local split = name:split("_")
	if not dungeon_loot.biomes[split[1]] then
		dungeon_loot.biomes[split[1]] = true
	end
end

local function noise3d_integer(noise, pos)
	return math.abs(math.floor(noise:get_3d(pos) * 0x7fffffff))
end

local function random_sample(rand, list, count)
	local ret = {}
	for _ = 1, count do
		local idx = rand:next(1, #list)
		table.insert(ret, list[idx])
		table.remove(list, idx)
	end
	return ret
end

local function get_dungeon_type(pos)
	local biome = core.get_biome_data(pos)
	biome = biome and core.get_biome_name(biome.biome) or ""
	local type = "normal"
	for bname, _ in pairs(dungeon_loot.biomes) do
		if biome:find(bname) then
			type = bname
		end
	end
	return type
end

local function populate_chest(pos, rand, dungeontype)
	--minetest.chat_send_all("chest placed at " .. minetest.pos_to_string(pos) .. " [" .. dungeontype .. "]")
	--minetest.add_node(vector.add(pos, {x=0, y=1, z=0}), {name="default:torch", param2=1})

	local item_list = dungeon_loot._internal_get_loot(pos.y, dungeontype)
	-- take random (partial) sample of all possible items
	local sample_n = math.min(#item_list, dungeon_loot.STACKS_PER_CHEST_MAX)
	item_list = random_sample(rand, item_list, sample_n)

	-- apply chances / randomized amounts and collect resulting items
	local items = {}
	for _, loot in ipairs(item_list) do
		if rand:next(0, 1000) / 1000 <= loot.chance then
			local itemdef = core.registered_items[loot.name]
			local amount = 1
			if loot.count ~= nil then
				amount = rand:next(loot.count[1], loot.count[2])
			end

			if not itemdef then
				core.log("warning", "Registered loot item " .. loot.name .. " does not exist")
			elseif itemdef.tool_capabilities then
				for _ = 1, amount do
					local wear = rand:next(0.20 * 65535, 0.75 * 65535) -- 20% to 75% wear
					table.insert(items, ItemStack({name = loot.name, wear = wear}))
				end
			elseif itemdef.stack_max == 1 then
				-- not stackable, add separately
				for _ = 1, amount do
					table.insert(items, loot.name)
				end
			else
				table.insert(items, ItemStack({name = loot.name, count = amount}))
			end
		end
	end

	-- place items at random places in chest
	local inv = core.get_meta(pos):get_inventory()
	local listsz = inv:get_size("main")
	assert(listsz >= #items)
	for _, item in ipairs(items) do
		local index = rand:next(1, listsz)
		if inv:get_stack("main", index):is_empty() then
			inv:set_stack("main", index, item)
		else
			inv:add_item("main", item) -- space occupied, just put it anywhere
		end
	end
end


--chest spots are found and placed by the async mapgen (mapgen_async.lua)
core.register_on_mods_loaded(function()
	core.ipc_set("fl_mapgen:chest_range", {dungeon_loot.CHESTS_MIN, dungeon_loot.CHESTS_MAX})
end)

local noise
local chest_def

core.register_on_generated(function()
	local gennotify = core.get_mapgen_object("gennotify")
	local poslist = gennotify["dungeon"] or {}
	for _, entry in ipairs(gennotify["temple"] or {}) do
		table.insert(poslist, entry)
	end
	if #poslist == 0 then return end

	noise = noise or core.get_value_noise({
		offset = 0,
		scale = 1,
		spread = {x = 1, y = 1, z = 1},
		seed = 10115,
		octaves = 4,
		persistence = 0.5,
	})
	chest_def = chest_def or core.registered_nodes["fl_storage:wood_chest"]

	-- same rooms the async mapgen looked at, chests sit at most 9 nodes from the center
	for i = 1, math.min(#poslist, 8) do
		local p = poslist[i]
		local chests = core.find_nodes_in_area(
			{x=p.x-9, y=p.y, z=p.z-9}, {x=p.x+9, y=p.y, z=p.z+9}, "fl_storage:wood_chest")
		for _, chestpos in ipairs(chests) do
			local inv = core.get_meta(chestpos):get_inventory()
			-- on_construct isn't run for nodes placed in mapgen, so a fresh chest has no inventory
			if inv:get_size("main") == 0 then
				chest_def.on_construct(chestpos)
				populate_chest(chestpos, PcgRandom(noise3d_integer(noise, chestpos)), get_dungeon_type(chestpos))
			end
		end
	end
end)
