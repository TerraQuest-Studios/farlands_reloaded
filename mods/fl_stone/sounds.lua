fl_stone.sounds = {}

function fl_stone.sounds.sand(input)
    input = input or {}
    input.dug = input.dug or {name = "farlands_dug_sand"}
    input.footstep = input.footstep or {name = "farlands_step_sand"}
    return input
end

function fl_stone.sounds.stone(input)
    input = input or {}
    input.dug = input.dug or {name = "farlands_dug_stone"}
    input.footstep = input.footstep or {name = "farlands_step_stone"}
    return input
end