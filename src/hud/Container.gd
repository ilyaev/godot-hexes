extends Container

var player_class = preload('Player.tscn')
onready var PlayersPanel = get_node('PlayersPanel')

var active_player = 0

func _ready():
	pass

func setup_game(players_count):
	for player in PlayersPanel.get_children():
		player.free()

	for index in range(players_count):
		var player = player_class.instance()
		player.index = index
		PlayersPanel.add_child(player)

	set_active_player(active_player)

func get_player(index):
	return PlayersPanel.get_children()[index]


func set_active_player(player_id):
	get_player(active_player).deactivate()
	active_player = player_id
	get_player(active_player).activate()
	pass


