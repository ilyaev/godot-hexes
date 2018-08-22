extends 'base.gd'

func _init():
    name = 'RESOLVE'

func on_enter():
    print('Resolve: ', index.win)
    if index.win:
        index.target_region.conquest(index.source_region)
    set_state(index.STATE_DEFAULT)