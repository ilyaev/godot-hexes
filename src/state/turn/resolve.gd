extends 'base.gd'

func _init():
    name = 'RESOLVE'

func on_enter():
    print('Resolve: ', index.win)
    if index.win:
        conquest_region()
    else:
        lose_battle()
    set_state(index.STATE_DEFAULT)

func conquest_region():
    var source = index.source_region
    var target = index.target_region

    target.set_country(source.country_id)
    target.turn_to_color(source.color)

    target.set_population(source.population - 1)
    source.set_population(1)


func lose_battle():
    var source = index.source_region
    source.set_population(1)
