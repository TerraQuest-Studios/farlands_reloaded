local bs = {}

bs.update_sec = 2
bs.defaults = {
    sky = {
        clouds = true,
        sky_color = {
            day_sky = "#8cbafa",
            day_horizon = "#9bc1f0",
            dawn_sky = "#b4bafa",
            dawn_horizon = "#bac1f0",
            night_sky = "#006aff",
            night_horizon = "#4090ff",
            indoors = "#646464",
            fog_tint_type = "default",
        }
    },
    sun = {
        visible = true,
        texture = "sun.png",
        tonemap = "sun_tonemap.png",
        sunrise = "sunrisebg.png",
        sunrise_visible = true,
        scale = 1,
    },
    moon = {
        visible = true,
        texture = "moon.png",
        tonemap = "moon_tonemap.png",
        scale = 1,
    },
    stars = {
        visible = true,
        count = 1000,
        star_color = "ebebff69",
        scale = 1,
    },
    clouds = {
        density = 0.3, -- default 0.4,
        color = "#fff0f0e5",
        ambient = "#000000",
        height = 120,
        thickness = 16,
        speed = {x = 0, z = -2},
    }
}
bs.players = {}

local function fill_data(default, input)
    local i = table.copy(input)

    for k, v in pairs(default) do
        if type(v) == "table" then
            if i[k] == nil then i[k] = {} end
            for k2, v2 in pairs(v) do
                if i[k][k2] == nil then i[k][k2] = v2 end
            end
        elseif i[k] == nil then
            i[k] = v
        end
    end

    return i
end

local function logic()
    for _, player in pairs(minetest.get_connected_players()) do
        local pname = player:get_player_name()
        local bdata = minetest.get_biome_data(player:get_pos())
        local bdef = minetest.registered_biomes[minetest.get_biome_name(bdata.biome)] or {}

        if bs.players[pname] and bs.players[pname].id == bdata.biome then break end

        if bdef._sky_data then
            for k, _ in pairs(bs.defaults) do
                if bdef._sky_data[k] == nil then bdef._sky_data[k] = {} end
            end

            player:set_sky(fill_data(bs.defaults.sky, bdef._sky_data.sky))
            player:set_sun(fill_data(bs.defaults.sun, bdef._sky_data.sun))
            player:set_moon(fill_data(bs.defaults.moon, bdef._sky_data.moon))
            player:set_stars(fill_data(bs.defaults.stars, bdef._sky_data.stars))
            player:set_clouds(fill_data(bs.defaults.clouds, bdef._sky_data.clouds))
            bs.players[pname] = {
                id = bdata.biome
            }
        else
            player:set_sky(bs.defaults.sky)
            player:set_sun(bs.defaults.sun)
            player:set_moon(bs.defaults.moon)
            player:set_stars(bs.defaults.stars)
            player:set_clouds(bs.defaults.clouds)
            bs.players[pname] = {
                id = bdata.biome
            }
        end
    end

    minetest.after(bs.update_sec, logic)
end

minetest.after(bs.update_sec, logic)