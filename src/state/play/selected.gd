extends 'base.gd'

func _init():
    name = 'SELECTED'

func on_enter():
    set_state(index.STATE_ROLL)