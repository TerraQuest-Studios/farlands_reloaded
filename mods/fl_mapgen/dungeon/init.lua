--sfan5 MIT
dungeon_loot = {}

dungeon_loot.CHESTS_MIN = 0 -- not necessarily in a single dungeon
dungeon_loot.CHESTS_MAX = 2
dungeon_loot.STACKS_PER_CHEST_MAX = 8

dofile(minetest.get_modpath("fl_mapgen") .. "/dungeon/loot.lua")
dofile(minetest.get_modpath("fl_mapgen") .. "/dungeon/mapgen.lua")