extends '../base.gd'

func _init():
    name = 'BASE'

func start():
    pass

func process_input(event):
    pass


func calculate_player_score(player_id):
    var player = index.players[player_id]
    player.score = 10
    return player.score
