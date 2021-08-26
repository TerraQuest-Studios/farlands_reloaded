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
            crumbly = {
                times = {[2] = 3.00, [3] = 0.70},
                uses = 0,
                maxlevel = 1,
            },
            snappy = {
                times = {[3] = 0.40},
                uses = 0,
                maxlevel = 1,
            },
            oddly_breakable_by_hand = {
                times = {[1] = 3.50, [2] = 2.00, [3] = 0.70},
                uses = 0,
            },
            dig_sand = {
                --1:sandstone brick/block 2:sandstone 3:sand
                times = {[1] = 6.00, [2] = 4.00, [3] = 0.75},
                uses = 0,
            },
            --[[
            dig_stone = {
                --1:stone brick/block 2:stone 3:rubble
                times = {[1] = 40.00, [2] = 38.00, [3] = 36},
                uses = 0,
            },
            --]]
        },
        damage_groups = {fleshy = 1},
    }
})

if minetest.settings:get_bool("creative_mode") then
    minetest.override_item("", {
        tool_capabilities = {
            full_punch_interval = 0.9,
            max_drop_level = 0,
            groupcaps = {
                oddly_breakable_by_hand = {
                    times = {[1] = 0, [2] = 0, [3] = 0},
                    uses = 0,
                },
                dig_sand = {
                    --1:sandstone brick/block 2:sandstone 3:sand
                    times = {[1] = 0, [2] = 0, [3] = 0},
                    uses = 0,
                },
                dig_stone = {
                    --1:stone brick/block 2:stone 3:rubble
                    times = {[1] = 0, [2] = 0, [3] = 0},
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