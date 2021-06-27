unused_args = false
allow_defined_top = true

exclude_files = {".luacheckrc"}

globals = {
    "minetest", "dungeon_loot"
}

read_globals = {
    string = {fields = {"split"}},
    table = {fields = {"copy", "getn"}},

    --luac
    "math", "table",

    -- Builtin
    "vector", "ItemStack", "dump", "DIR_DELIM", "VoxelArea", "Settings", "PcgRandom",

    --mod produced
    "fl_dyes", "fl_hand", "fl_tools", "fl_workshop", "mobkit",
}