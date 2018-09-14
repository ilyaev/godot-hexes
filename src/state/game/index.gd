extends '../index_base.gd'

const STATE_DEFAULT = 0
const STATE_SETUP = 1

var Camera
var Arrow
var Hud

var turn = 0
var player = 0


func _init():
    name = 'GAME'
    state_classes = [
        preload("default.gd").new(),
        preload("setup.gd").new()
    ]

func _ready():
    Camera = scene.get_node('Camera')
    Arrow = scene.get_node('Arrow')
    Hud = scene.Hud
    set_state(STATE_DEFAULT)


func start():
    state.start()