extends 'base.gd'

func _init():
    name = 'APPLY_SCORE'

signal calculated

var toadd = 0
var added = 0
var regions

func on_enter():
    var score = scene.game.players[scene.game.active_player].score
    regions = scene.Grid.get_regions_by_player_id(scene.game.active_player)

    for next in regions:
        next.connect("population_increase_animation_completed", self, "population_added", [next])

    toadd = 0
    added = 0

    for index in range(score):
        var next = get_next_region_to_populate(regions)
        if next:
            toadd = toadd + 1
            next.increase_population()

    if toadd == 0:
        set_state(index.STATE_MAKE_TURN)

    pass

func on_exit():
    for next in regions:
        next.disconnect("population_increase_animation_completed", self, "population_added")

func population_added(region):
    added = added + 1
    if toadd == added:
        set_state(index.STATE_MAKE_TURN)

func get_next_region_to_populate(regions):
    var incompletes = []
    for region in regions:
        if region.population < 8:
            incompletes.append(region)

    if incompletes.size() <= 0:
        return false

    return incompletes[randi() % incompletes.size()]