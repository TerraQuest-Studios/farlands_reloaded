fl_trees = {}

fl_trees.types = {"acacia", "aspen", "pine", "spruce", "yellow_ipe", "willow", "baobab", "palm", "jungletree", "apple"}

local modpath = core.get_modpath("fl_trees")

dofile(modpath .. "/sounds.lua")
dofile(modpath .. "/nodes.lua")
dofile(modpath .. "/saplings.lua")

fl_trees.init = true