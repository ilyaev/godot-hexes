extends 'base.gd'

var Hud

func _init():
    name = 'SETUP'

func on_enter():
    Hud = scene.Hud
    Hud.setup_game(scene.players_count)
    pass