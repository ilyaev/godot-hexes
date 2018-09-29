extends 'base.gd'

func _init():
    name = 'DEFAULT'

func on_enter():
    scene.region_selection.set_state(scene.region_selection.STATE_DEFAULT)
    pass

func on_region_clicked(region):
    set_state(index.STATE_SELECTION)

