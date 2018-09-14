extends TextureRect

var index = -1

func _ready():
	pass

func activate():
	modulate = Color(1,0,0,1)

func deactivate():
	modulate = Color(1,1,1,1)
