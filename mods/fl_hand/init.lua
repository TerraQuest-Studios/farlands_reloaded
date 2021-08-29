fl_hand = {}

fl_hand.details = {
    version = 1,
    name = "fl_hand",
    author = "wsor",
    license = "MIT",
}

minetest.register_item(":", {
    type = "none",
    wield_image = "farlands_hand.png",
    wield_scale = {x = 1, y = 1, z = 2.5},
    --.2 added to range for snek
    range = 5.2,
    tool_capabilities = {
        full_punch_interval = 0.9,
        max_drop_level = 0,
        groupcaps = {
            oddly_breakable_by_hand = {
                --exists for debug/devolpement group
                times = {[1] = 3.50, [2] = 2.00, [3] = 0.50},
                uses = 0,
            },
            dig_generic = {
                --generic digging groups, set times, not modified by anything
                times = {[1] = 3, [2] = 2, [3] = 1, [4] = 0.5},
                uses = 0,
            },
            dig_sand = {
                --1:sandstone brick/block 2:sandstone 3:sand
                times = {[1] = 6.00, [2] = 4.00, [3] = 0.75},
                uses = 0,
            },
            dig_glass = {
                --1:glass block 2:glass pane
                times = {[1] = 4.00, [2] = 1.00,},
                uses = 0,
            },
            dig_tree = {
                --1:tree trunk 2:tree planks/fence 3:tree leaves
                times = {[1] = 3.5, [2] = 3, [3] = 0.3},
                uses = 0,
            },
            dig_snow = {
                --1:codensed ice 2:ice 3:snow block 4:snow
                times = {[1] = 5, [2] = 0.75, [3] = 1, [4] = 0.5},
                uses = 0,
            },
            dig_dirt = {
                --1:dirt with * 2:farmland 3:dirt
                times = {[1] = 1, [2] = 0.9, [3] = 0.75},
                uses = 0,
            },
        },
        damage_groups = {fleshy = 1},
    }
})

--var for all creative dig time
local cdig = 0.15

if minetest.settings:get_bool("creative_mode") then
    minetest.override_item("", {
        tool_capabilities = {
            full_punch_interval = 0.9,
            max_drop_level = 0,
            groupcaps = {
                oddly_breakable_by_hand = {
                    times = {[1] = cdig, [2] = cdig, [3] = cdig},
                    uses = 0,
                },
                dig_generic = {
                    --generic digging groups, set times, not modified by anything
                    times = {[1] = cdig, [2] = cdig, [3] = cdig, [4] = cdig},
                    uses = 0,
                },
                dig_sand = {
                    --1:sandstone brick/block 2:sandstone 3:sand
                    times = {[1] = cdig, [2] = cdig, [3] = cdig},
                    uses = 0,
                },
                dig_stone = {
                    --1:stone brick/block 2:stone 3:rubble
                    times = {[1] = cdig, [2] = cdig, [3] = cdig},
                    uses = 0,
                },
                dig_glass = {
                    --1:glass block 2:glass pane
                    times = {[1] = cdig, [2] = cdig,},
                    uses = 0,
                },
                dig_tree = {
                    --1:tree trunk 2:tree planks/fence 3:tree leaves
                    times = {[1] = cdig, [2] = cdig, [3] = cdig},
                    uses = 0,
                },
                dig_snow = {
                    --1:codensed ice 2:ice 3:snow block 4:snow
                    times = {[1] = cdig, [2] = cdig, [3] = cdig, [4] = cdig},
                    uses = 0,
                },
                dig_dirt = {
                    --1:dirt with * 2:farmland 3:dirt
                    times = {[1] = cdig, [2] = cdig, [3] = cdig},
                    uses = 0,
                },
            },
        },
    })
end

--[[
minetest.register_node(":debug:tgi", {
    drawtype = "airlike",
    description = "test group item",
    light_source = minetest.LIGHT_MAX,
    groups = {test_group = 1}
})
--]]