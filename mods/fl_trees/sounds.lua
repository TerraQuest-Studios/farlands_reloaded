fl_trees.sounds = {}

function fl_trees.sounds.wood(input)
    input = input or {}
    input.dug = input.dug or {name = "farlands_dug_wood"}
    input.footstep = input.footstep or {name = "farlands_step_wood"}
    return input
end