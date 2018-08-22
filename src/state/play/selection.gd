extends 'base.gd'

func _init():
    name = 'SELECTION'

func resolve_selection(source_region, target_region):
    index.source_region = source_region
    index.target_region = target_region
    set_state(index.STATE_SELECTED)