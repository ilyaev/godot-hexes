extends Spatial

var HexGrid_class = preload('res://src/hex/Grid.tscn')
var Grid

func _ready():
	Grid = HexGrid_class.instance()

	add_child(Grid)
	# var thread = Thread.new()
	# thread.start(self, 'add_hexgrid', [thread])
	pass

func add_hexgrid(params):
	add_child(Grid)
	params[0].wait_to_finish()
