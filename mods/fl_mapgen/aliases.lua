minetest.register_alias("mapgen_stone", "fl_stone:stone")
if minetest.get_mapgen_setting("mg_name") == "valleys" then
    minetest.register_alias("mapgen_water_source", "fl_liquids:river_water_source")
    minetest.register_alias("mapgen_river_water_source", "fl_liquids:river_water_source")
else
    minetest.register_alias("mapgen_water_source", "fl_liquids:water_source")
    minetest.register_alias("mapgen_river_water_source", "fl_liquids:water_source")
end