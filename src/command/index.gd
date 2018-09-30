extends Node

var scene

var classes = [
    preload('./start_round.gd'),
    preload('./end_turn.gd'),
    preload('./select_source_region.gd'),
    preload('./select_target_region.gd'),
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
