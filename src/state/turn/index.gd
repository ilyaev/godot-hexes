extends '../index_base.gd'

const STATE_DEFAULT = 0
const STATE_SELECTION = 1
const STATE_SELECTED = 2
const STATE_ROLL = 3
const STATE_RESOLVE = 4

var Camera
var Arrow

var source_region
var target_region
var win


func _init():
    name = 'PLAY'
    state_classes = [
        preload("default.gd").new(),
        preload("selection.gd").new(),
        preload("selected.gd").new(),
        preload("roll.gd").new(),
        preload("resolve.gd").new()
    ]

func _ready():
    Camera = scene.get_node('Camera')
    Arrow = scene.get_node('Arrow')
    set_state(STATE_DEFAULT)


func on_region_clicked(region, position):
    state.on_region_clicked(region, position)


func resolve_selection(source_region, target_region):
    state.resolve_selection(source_region, target_region)

func cancel_selection():
    set_state(STATE_DEFAULT)