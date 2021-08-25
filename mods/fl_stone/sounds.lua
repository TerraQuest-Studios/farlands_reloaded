fl_stone.sounds = {}

function fl_stone.sounds.sand(input)
    input = input or {}
    input.dig = input.dig or {name = "farlands_dug_sand"}
    input.footstep = input.footstep or {name = "farlands_step_sand", gain = 0.75}
    return input
end

function fl_stone.sounds.stone(input)
    input = input or {}
    input.dig = input.dig or {name = "farlands_dug_stone"}
    input.footstep = input.footstep or {name = "farlands_step_stone", gain = 0.5}
    return input
end