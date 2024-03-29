unused_args = false
allow_defined_top = true
exclude_files = {".luacheckrc"}

globals = {
    "minetest",

    --mod provided
    "fl_wildlife", "fl_brains"
}

read_globals = {
    string = {fields = {"split"}},
    table = {fields = {"copy", "getn"}},

    -- Builtin
    "vector", "ItemStack",
    "dump", "DIR_DELIM", "VoxelArea", "Settings",

    -- MTG
    "default", "sfinv", "creative", "carts",

    --depends
    "mobkit", "fl_dyes",
}