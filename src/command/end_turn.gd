extends './base.gd'

func _init():
   name = 'END_TURN'

func set_params(params):
   pass

func execute():
    scene.region_selection.set_state(scene.region_selection.STATE_DEFAULT)

    var current_player = scene.game.active_player
    var score = scene.game.calculate_player_score(current_player)
    scene.game.set_state(scene.game.STATE_APPLY_SCORE)
    current_player = current_player + 1
    if current_player >= scene.players_count:
        current_player = 0
    scene.game.set_active_player(current_player)

    pass