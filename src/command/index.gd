extends Node

var scene

var classes = [
    preload('./region_select.gd'),
    preload('./selection_arrow_show.gd')
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
