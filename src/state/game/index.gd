extends '../index_base.gd'

const STATE_DEFAULT = 0
const STATE_SETUP = 1
const STATE_MAKE_TURN = 2

var Camera
var Arrow
var Hud

var turn = 0
var active_player = 0



func _init():
    name = 'GAME'
    state_classes = [
        preload("default.gd").new(),
        preload("setup.gd").new(),
        preload("make_turn.gd").new()
    ]

func _ready():
    Camera = scene.get_node('Camera')
    Arrow = scene.get_node('Arrow')
    Hud = scene.Hud
    set_state(STATE_DEFAULT)

func set_active_player(player_index):
    active_player = player_index
    Hud.set_active_player(active_player)

func start():
    state.start()

func process_input(event):
    return state.process_input(event)