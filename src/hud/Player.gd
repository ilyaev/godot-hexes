extends TextureRect

var index = -1
var score = 0

func _ready():
	modulate = global.get_player_color(index)
	pass

func activate():
	$Active.show()

func deactivate():
	$Active.hide()
