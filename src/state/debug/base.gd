extends "../base.gd"

var Camera
var Arrow

func _init():
    name = 'BASE'

func on_enter():
    Camera = scene.get_node('Camera')
    Arrow = scene.get_node('Arrow')