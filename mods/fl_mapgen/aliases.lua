core.register_alias("mapgen_stone", "fl_stone:stone")
if core.get_mapgen_setting("mg_name") == "valleys" then
    core.register_alias("mapgen_water_source", "fl_liquids:river_water_source")
    core.register_alias("mapgen_river_water_source", "fl_liquids:river_water_source")
else
    core.register_alias("mapgen_water_source", "fl_liquids:water_source")
    core.register_alias("mapgen_river_water_source", "fl_liquids:water_source")
end