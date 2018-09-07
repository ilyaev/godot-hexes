extends '../index_base.gd'

const STATE_DEFAULT = 0

var Camera

func _init():
    name = 'DEBUG'
    state_classes = [
        preload("default.gd").new(),
    ]

func _ready():
    Camera = scene.get_node('Camera')
    set_state(STATE_DEFAULT)
