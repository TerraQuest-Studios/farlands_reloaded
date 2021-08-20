fl_topsoil.sounds = {}

function fl_topsoil.sounds.snow(input)
    input = input or {}
    input.dug = input.dug or {name = "farlands_dug_snow"}
    input.footstep = input.footstep or {name = "farlands_step_snow", gain = 0.15}
    return input
end

function fl_topsoil.sounds.gravel(input)
    input = input or {}
    input.dug = input.dug or {name = "farlands_dug_gravel"}
    input.footstep = input.footstep or {name = "farlands_step_gravel", gain = 0.5}
    return input
end

function fl_topsoil.sounds.grass(input)
    input = input or {}
    input.dug = input.dug or {name = "farlands_dug_grass"}
    input.footstep = input.footstep or {name = "farlands_step_grass", gain = 0.25}
    return input
end