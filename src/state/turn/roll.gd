extends 'base.gd'

func _init():
    name = 'ROLL'

func on_enter():
    print('Roll: ', [index.source_region.population, ' vs. ', index.target_region.population])
    index.win = false
    if index.source_region.population > index.target_region.population:
        index.win = true
    set_state(index.STATE_RESOLVE)