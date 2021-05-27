--this is for tools that have pick/axe/shovel/hoe/sword/etc

--quick and dirty to get them in game, this needs to be fine tuned later
local function make_tool_set(name)
    minetest.register_tool("fl_tools:" .. name .. "_pick", {
        description = name .. " pick",
        inventory_image = "farlands_" .. name .. "_pick.png",
        tool_capabilities = {
            max_group_level = 3,
            group_caps = {
                cracky={times={[1]=4.00, [2]=1.50, [3]=1.00}, uses=70, maxlevel=1},
            }
        },
        groups = {tool = 1},
    })
    minetest.register_tool("fl_tools:" .. name .. "_axe", {
        description = name .. " axe",
        inventory_image = "farlands_" .. name .. "_axe.png",
        tool_capabilities = {
            max_group_level = 3,
            group_caps = {
                cracky={times={[1]=4.00, [2]=1.50, [3]=1.00}, uses=70, maxlevel=1}
            }
        },
        groups = {tool = 1},
    })
    minetest.register_tool("fl_tools:" .. name .. "_shovel", {
        description = name .. " shovel",
        inventory_image = "farlands_" .. name .. "_shovel.png",
        tool_capabilities = {
            max_group_level = 3,
            group_caps = {
                cracky={times={[1]=4.00, [2]=1.50, [3]=1.00}, uses=70, maxlevel=1}
            }
        },
        groups = {tool = 1},
    })
    minetest.register_tool("fl_tools:" .. name .. "_sword", {
        description = name .. " sword",
        inventory_image = "farlands_" .. name .. "_sword.png",
        tool_capabilities = {
            max_group_level = 3,
            group_caps = {
                cracky={times={[1]=4.00, [2]=1.50, [3]=1.00}, uses=70, maxlevel=1}
            }
        },
        groups = {tool = 1},
    })
    minetest.register_tool("fl_tools:" .. name .. "_hoe", {
        description = name .. " hoe",
        inventory_image = "farlands_" .. name .. "_hoe.png",
        tool_capabilities = {
            max_group_level = 3,
            group_caps = {
                cracky={times={[1]=4.00, [2]=1.50, [3]=1.00}, uses=70, maxlevel=1}
            }
        },
        groups = {tool = 1},
    })
end

make_tool_set("bronze")
make_tool_set("diamond")
make_tool_set("gold")
make_tool_set("steel")
make_tool_set("stone")
make_tool_set("wood")

--very, very crappy way to add anvil recipes
local tool_upgrades = {
    wood = {"fl_stone:stone", "stone"},
    stone = {"fl_ores:steel_ore", "steel"},
    steel = {"fl_ores:bronze_ore", "bronze"},
    bronze = {"fl_ores:gold_ore", "gold"},
    gold = {"fl_ores:diamond_ore", "diamond"},
    --diamond = ,
}

local types = {"_pick", "_axe", "_shovel", "_sword", "_shovel", "_hoe"}

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