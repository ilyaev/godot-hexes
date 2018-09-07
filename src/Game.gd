extends Spatial

var HexGrid_class = preload('res://src/hex/Grid.tscn')
var Grid
var original_transform
var tween = Tween.new()
var region_selection = preload('./state/region_selection/index.gd').new()
var turn = preload('./state/turn/index.gd').new()
var debug = preload('./state/debug/index.gd').new()

func _ready():
	randomize()

	Grid = HexGrid_class.instance()
	Grid.build_all()
	add_child(Grid)

	fit_to_screen()

	add_child(tween)

	init_states()

	pass

func fit_to_screen():
	var scale = 1
	$Camera.transform = $Camera.transform.rotated(Vector3(1,0,0), PI/8).translated(Vector3(0,-0.2,0)).scaled(Vector3(scale, scale, scale))
	original_transform = $Camera.transform

func init_states():
	region_selection.scene = self
	turn.scene = self
	debug.scene = self

	global.connect('region_clicked', turn, 'on_region_clicked')
	region_selection.connect('selected', turn, 'resolve_selection')
	region_selection.connect('wrong_selection', turn, 'cancel_selection')

	add_child(region_selection)
	add_child(turn)
	add_child(debug)


func _input(event):
	region_selection.process_input(event)
	debug.process_input(event)