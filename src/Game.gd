extends Spatial

var HexGrid_class = preload('res://src/hex/Grid.tscn')
var Grid
var original_transform
var tween = Tween.new()
var region_selection = preload('./state/region_selection/index.gd').new()
var turn = preload('./state/turn/index.gd').new()
var debug = preload('./state/debug/index.gd').new()
var game = preload('./state/game/index.gd').new()

onready var Hud = get_node('HudCanvas/Hud')
onready var PlayersPanel = get_node('HudCanvas/Hud/PlayersPanel')


var players_count = 3


func _ready():
	randomize()

	Grid = HexGrid_class.instance()
	Grid.country_count = players_count
	Grid.build_all()
	add_child(Grid)

	fit_to_screen()

	add_child(tween)

	init_states()
	init_commands()

	start_game()

	pass

func start_game():
	game.start()
	pass


func fit_to_screen():
	var scale = 1
	$Camera.transform = $Camera.transform.rotated(Vector3(1,0,0), PI/8).translated(Vector3(0,-0.2,0)).scaled(Vector3(scale, scale, scale))
	original_transform = $Camera.transform

func init_states():
	region_selection.scene = self
	turn.scene = self
	debug.scene = self
	game.scene = self

	global.connect('region_clicked', turn, 'on_region_clicked')
	region_selection.connect('selected', turn, 'resolve_selection')
	region_selection.connect('wrong_selection', turn, 'cancel_selection')

	add_child(region_selection)
	add_child(turn)
	add_child(debug)
	add_child(game)

func get_active_player():
	return game.active_player

func init_commands():
	commands.index.scene = self


func _input(event):
	add_commands(region_selection.process_input(event))
	add_commands(debug.process_input(event))
	add_commands(game.process_input(event))

func add_commands(items):
	if typeof(items) == TYPE_ARRAY and items.size() > 0:
		for cmd in items:
			if cmd.has('id'):
				commands.add(cmd)