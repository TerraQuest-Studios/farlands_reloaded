fl_trees.sounds = {}

function fl_trees.sounds.wood(input)
    input = input or {}
    input.dig = input.dig or {name = "farlands_dug_wood"}
    input.footstep = input.footstep or {name = "farlands_step_wood", gain = 0.75}
    return input
end