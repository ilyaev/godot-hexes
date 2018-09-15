extends Node

var scene

var classes = [
    preload('./region_select.gd'),
    preload('./selection_arrow_show.gd'),
    preload('./selection_arrow_move.gd'),
    preload('./start_round.gd'),
    preload('./end_turn.gd'),
    # %%NEXT_CMD%%
]

func _init():
    pass

func add(params):
    var cmd = classes[params.id].new()
    cmd.scene = scene
    cmd.set_params(params)
    if global.DEBUG.commands:
        print("CMD: ", [cmd.name, params])
    cmd.execute()
    cmd.free()
