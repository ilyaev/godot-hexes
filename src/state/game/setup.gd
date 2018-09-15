extends 'base.gd'

var Hud

func _init():
    name = 'SETUP'

func on_enter():
    Hud = scene.Hud
    Hud.setup_game(scene.players_count)
    scene.game.set_active_player(0)
    set_state(index.STATE_MAKE_TURN)
    pass