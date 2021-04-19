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
        }
    })
    minetest.register_tool("fl_tools:" .. name .. "_axe", {
        description = name .. " axe",
        inventory_image = "farlands_" .. name .. "_axe.png",
        tool_capabilities = {
            max_group_level = 3,
            group_caps = {
                cracky={times={[1]=4.00, [2]=1.50, [3]=1.00}, uses=70, maxlevel=1}
            }
        }
    })
    minetest.register_tool("fl_tools:" .. name .. "_shovel", {
        description = name .. " shovel",
        inventory_image = "farlands_" .. name .. "_shovel.png",
        tool_capabilities = {
            max_group_level = 3,
            group_caps = {
                cracky={times={[1]=4.00, [2]=1.50, [3]=1.00}, uses=70, maxlevel=1}
            }
        }
    })
    minetest.register_tool("fl_tools:" .. name .. "_sword", {
        description = name .. " sword",
        inventory_image = "farlands_" .. name .. "_sword.png",
        tool_capabilities = {
            max_group_level = 3,
            group_caps = {
                cracky={times={[1]=4.00, [2]=1.50, [3]=1.00}, uses=70, maxlevel=1}
            }
        }
    })
    minetest.register_tool("fl_tools:" .. name .. "_hoe", {
        description = name .. " hoe",
        inventory_image = "farlands_" .. name .. "_hoe.png",
        tool_capabilities = {
            max_group_level = 3,
            group_caps = {
                cracky={times={[1]=4.00, [2]=1.50, [3]=1.00}, uses=70, maxlevel=1}
            }
        }
    })
end

make_tool_set("bronze")
make_tool_set("diamond")
make_tool_set("gold")
make_tool_set("steel")
make_tool_set("stone")
make_tool_set("wood")