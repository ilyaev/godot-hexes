extends "../index_base.gd"

const STATE_DEFAULT = 0
const SELECTED_SOURCE = 1

var source_selection_id = -1
var source_selection

var target_selection_id = -1
var target_selection

signal selected
signal wrong_selection

func _init():
    name = 'SELECTION'
    state_classes = [
        preload("default.gd").new(),
        preload("selected_source.gd").new()
    ]

func _ready():
    set_state(STATE_DEFAULT)

func on_region_clicked(region, position):
    state.on_region_clicked(region, position)