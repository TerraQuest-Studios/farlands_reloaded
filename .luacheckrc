unused_args = false
allow_defined_top = true

exclude_files = {".luacheckrc"}

globals = {
    "minetest", "core", 
    
    --mod provided
    "dungeon_loot", "fl_workshop", "fl_player", "fl_stone", "fl_trees", "fl_topsoil", "fl_plantlife"
}

read_globals = {
    string = {fields = {"split"}},
    table = {fields = {"copy", "getn"}},

    --luac
    "math", "table",

    -- Builtin
    "vector", "ItemStack", "dump", "DIR_DELIM", "VoxelArea", "Settings", "PcgRandom", "VoxelManip", "PseudoRandom",

    --mod produced
    "fl_dyes", "fl_hand", "fl_tools", "mobkit", "fl_tnt", "i3",
}