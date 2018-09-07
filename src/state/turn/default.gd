extends 'base.gd'

func _init():
    name = 'DEFAULT'

func on_enter():
    pass

func on_region_clicked(region, position):
    scene.region_selection.on_region_clicked(region, position)
    set_state(index.STATE_SELECTION)

