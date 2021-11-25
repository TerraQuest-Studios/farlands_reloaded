--damage_groups need to be adressed

local tool_use = {
    wood = 10,
    stone = 15,
    steel = 20,
    bronze = 30,
    gold = 40,
    diamond = 50,
}

local material_list = {
    wood = "group:plank",
    stone = "fl_stone:stone",
    steel = "fl_ores:iron_ingot",
    bronze = "fl_ores:bronze_ingot",
    gold = "fl_ores:gold_ingot",
}

local function make_pickaxe(name, factor)
    if not factor then factor = {} end
    minetest.register_tool("fl_tools:" .. name .. "_pick", {
        description = name .. " pick",
        inventory_image = "farlands_" .. name .. "_pick.png",
        tool_capabilities = {
            full_punch_interval = 1.2,
            max_drop_level = 0,
            groupcaps = {
                dig_sand = {
                    --1:sandstone brick/block 2:sandstone 3:sand
                    times={[1] = 6/(factor[1] or 1), [2] = 4/(factor[1] or 1)},
                    uses=tool_use[name],
                    maxlevel=1
                },
                dig_stone = {
                    --1:stone brick/block 2:stone 3:rubble
                    times = {[1] = 8/(factor[2] or 1), [2] = 6/(factor[2] or 1), [3] = 4/(factor[2] or 1)},
                    uses=tool_use[name],
                    maxlevel=1
                },
                dig_glass = {
                    --1:glass block 2:glass pane
                    times = {[1] = 4.00/(factor[3] or 1), [2] = 1.00/(factor[3] or 1),},
                    uses=tool_use[name],
                    maxlevel=1
                },
                dig_snow = {
                    --1:codensed ice 2:ice 3:snow block 4:snow
                    times = {[1] = 5/(factor[4] or 1), [2] = 0.75/(factor[4] or 1)},
                    uses=tool_use[name],
                    maxlevel=1
                },
            },
            damage_groups = {fleshy=2},
        },
        _dungeon_loot = {chance = math.random(0.01, 0.2)},
        groups = {tool = 1},
    })

    local material = material_list[name] or "fl_ores:" .. name .. "_ore"
    minetest.register_craft({
        output = "fl_tools:" .. name .. "_pick",
        recipe = {
            {material, material, material},
            {"", "fl_trees:stick", ""},
            {"", "fl_trees:stick", ""},
        }
    })
end

make_pickaxe("wood", {1.5, nil, 1.5, 0.9})
make_pickaxe("stone", {2, 2.3, 2, 1.8})
make_pickaxe("steel", {2.5, 3.6, 2.5, 2.7})
make_pickaxe("bronze", {3, 4.9, 3, 3.6})
make_pickaxe("gold", {3.5, 6.2, 3.5, 4.5})
make_pickaxe("diamond", {4, 7.5, 4, 5.4})

local function make_axe(name, factor)
    if not factor then factor = {} end
    minetest.register_tool("fl_tools:" .. name .. "_axe", {
        description = name .. " axe",
        inventory_image = "farlands_" .. name .. "_axe.png",
        tool_capabilities = {
            full_punch_interval = 1.2,
            max_drop_level = 0,
            groupcaps = {
                dig_tree = {
                    --1:tree trunk 2:tree planks/fence 3:tree leaves
                    times = {[1] = 3.5/(factor[1] or 1), [2] = 3/(factor[1] or 1)},
                    uses = tool_use[name],
                },
            },
            damage_groups = {fleshy=2},
        },
        _dungeon_loot = {chance = math.random(0.1, 0.2)},
        groups = {tool = 1},
    })

    local material = material_list[name] or "fl_ores:" .. name .. "_ore"
    minetest.register_craft({
        output = "fl_tools:" .. name .. "_axe",
        recipe = {
            {material, material, ""},
            {material, "fl_trees:stick", ""},
            {"", "fl_trees:stick", ""},
        }
    })

    minetest.register_craft({
        output = "fl_tools:" .. name .. "_axe",
        recipe = {
            {"", material, material},
            {"", "fl_trees:stick", material},
            {"", "fl_trees:stick", ""},
        }
    })
end

make_axe("wood", {1.2})
make_axe("stone", {2.4})
make_axe("steel", {3.6})
make_axe("bronze", {4.8})
make_axe("gold", {6})
make_axe("diamond", {7.2})

local function make_shovel(name, factor)
    if not factor then factor = {} end
    minetest.register_tool("fl_tools:" .. name .. "_shovel", {
        description = name .. " shovel",
        inventory_image = "farlands_" .. name .. "_shovel.png",
        tool_capabilities = {
            full_punch_interval = 1.2,
            max_drop_level = 0,
            groupcaps = {
                dig_sand = {
                    --1:sandstone brick/block 2:sandstone 3:sand
                    times={[3] = 0.75/(factor[1] or 1)},
                    uses=tool_use[name],
                    maxlevel=1
                },
                dig_snow = {
                    --1:codensed ice 2:ice 3:snow block 4:snow
                    times = {[3] = 1/(factor[2] or 1), [4] = 0.5/(factor[2] or 1)},
                    uses=tool_use[name],
                    maxlevel=1
                },
                dig_dirt = {
                    --1:dirt with * 2:farmland 3:dirt
                    times = {[1] = 1/(factor[3] or 1), [2] = 0.9/(factor[3] or 1), [3] = 0.75/(factor[3] or 1)},
                    uses=tool_use[name],
                    maxlevel=1
                },
            },
            damage_groups = {fleshy=2},
        },
        _dungeon_loot = {chance = math.random(0.01, 0.1)},
        groups = {tool = 1},
    })

    local material = material_list[name] or "fl_ores:" .. name .. "_ore"
    minetest.register_craft({
        output = "fl_tools:" .. name .. "_shovel",
        recipe = {
            {material},
            {"fl_trees:stick"},
            {"fl_trees:stick"},
        }
    })
end

make_shovel("wood", {0.7, 0.8, 1})
make_shovel("stone", {1.4, 1.6, 2})
make_shovel("steel", {2.1, 2.4, 3})
make_shovel("bronze", {2.8, 3.2, 4})
make_shovel("gold", {3.5, 4, 5})
make_shovel("diamond", {4.2, 4.8, 6})

--adress damage groups for mobs
local function make_sword(name, factor)
    if not factor then factor = {} end
    minetest.register_tool("fl_tools:" .. name .. "_sword", {
        description = name .. " sword",
        inventory_image = "farlands_" .. name .. "_sword.png",
        tool_capabilities = {
            full_punch_interval = 1.2,
            max_drop_level = 0,
            groupcaps = {
                oddly_breakable_by_hand = {
                    times = {[1] = 1/(factor[1] or 1), [2] = 1/(factor[1] or 1), [3] = 1/(factor[1] or 1)},
                    uses = tool_use[name],
                },
            },
            damage_groups = {fleshy=2},
        },
        _dungeon_loot = {chance = math.random(0.01, 0.09)},
        groups = {tool = 1},
    })

    local material = material_list[name] or "fl_ores:" .. name .. "_ore"
    minetest.register_craft({
        output = "fl_tools:" .. name .. "_sword",
        recipe = {
            {material},
            {material},
            {"fl_trees:stick"},
        }
    })
end

make_sword("wood")
make_sword("stone")
make_sword("steel")
make_sword("bronze")
make_sword("gold")
make_sword("diamond")

--need to add in tool wear
local function make_hoe(name, factor)
    if not factor then factor = {} end
    minetest.register_tool("fl_tools:" .. name .. "_hoe", {
        description = name .. " hoe",
        inventory_image = "farlands_" .. name .. "_hoe.png",
        tool_capabilities = {
            full_punch_interval = 1.2,
            max_drop_level = 0,
            groupcaps = {
                oddly_breakable_by_hand = {
                    times = {[1] = 1/(factor[1] or 1), [2] = 1/(factor[1] or 1), [3] = 1/(factor[1] or 1)},
                    uses = tool_use[name],
                },
            },
            damage_groups = {fleshy=2},
        },
        on_use = function(itemstack, user, pointed_thing)
            if pointed_thing.type ~= "node" then return end
            local node = minetest.get_node_or_nil(pointed_thing.under)
            if not node then return end
            if minetest.get_node_group(node.name, "farm_convert") == 1 then
                minetest.swap_node(pointed_thing.under, {name = "fl_topsoil:dry_farmland"})
            end
        end,
        _dungeon_loot = {chance = math.random(0.1, 0.3)},
        groups = {tool = 1},
    })

    local material = material_list[name] or "fl_ores:" .. name .. "_ore"
    minetest.register_craft({
        output = "fl_tools:" .. name .. "_hoe",
        recipe = {
            {material, material, ""},
            {"", "fl_trees:stick", ""},
            {"", "fl_trees:stick", ""},
        }
    })

    minetest.register_craft({
        output = "fl_tools:" .. name .. "_hoe",
        recipe = {
            {"", material, material},
            {"", "fl_trees:stick", ""},
            {"", "fl_trees:stick", ""},
        }
    })
end

make_hoe("wood")
make_hoe("stone")
make_hoe("steel")
make_hoe("bronze")
make_hoe("gold")
make_hoe("diamond")

--very, very crappy way to add anvil recipes
local tool_upgrades = {
    wood = {"fl_stone:stone", "stone"},
    stone = {"fl_ores:steel_ore", "steel"},
    steel = {"fl_ores:bronze_ore", "bronze"},
    bronze = {"fl_ores:gold_ore", "gold"},
    gold = {"fl_ores:diamond_ore", "diamond"},
    --diamond = ,
}

local types = {"_pick", "_axe", "_shovel", "_sword", "_hoe"}

local function make_anvil_crafts(name)
    for _, type in pairs(types) do
        fl_workshop.register_anvil_craft({
            recipe = {"fl_tools:" .. name .. type, tool_upgrades[name][1]},
            output = "fl_tools:" .. tool_upgrades[name][2] .. type
        })
    end
end

make_anvil_crafts("bronze")
make_anvil_crafts("gold")
make_anvil_crafts("steel")
make_anvil_crafts("stone")
make_anvil_crafts("wood")

if minetest.get_modpath("i3") then
    for _, type in pairs(types) do
        i3.compress("fl_tools:diamond" .. type, {
            replace = "diamond",
            by = {"wood", "stone", "steel", "gold", "bronze"}
        })
    end
end