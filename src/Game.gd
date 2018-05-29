extends Spatial

var HexGrid_class = preload('res://src/hex/Grid.tscn')
var Grid
var prev_mouse_position = Vector3(0,0,0)
var original_transform
var free_look = false
var tween = Tween.new()
var light_tween = Tween.new()

func _ready():
	Grid = HexGrid_class.instance()

	add_child(Grid)
	add_child(tween)
	add_child(light_tween)
	original_transform = $Camera.transform
	# var thread = Thread.new()
	# thread.start(self, 'add_hexgrid', [thread])
	pass

func add_hexgrid(params):
	add_child(Grid)
	params[0].wait_to_finish()

func _input(event):
	if Input.is_key_pressed(KEY_SPACE):
		if !free_look:
			prev_mouse_position.x = 0
		free_look = true
	else:
		if free_look:
			# $DirectionalLight.transform = original_transform

			light_tween.interpolate_property($DirectionalLight, 'transform', $DirectionalLight.transform, original_transform, 0.6, Tween.TRANS_SINE, Tween.EASE_IN)
			light_tween.start()

			tween.interpolate_property($Camera, 'transform', $Camera.transform, original_transform, 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
			tween.start()


		free_look = false

	if free_look and event is InputEventMouseMotion:
		if prev_mouse_position.x == 0:
			prev_mouse_position = event.position
		var diff = event.position - prev_mouse_position
		$Camera.transform = original_transform.rotated(Vector3(0,1,0), PI / 2 * diff.x / 300).rotated(Vector3(1,0,0), PI / 2 * diff.y / 300)
		$DirectionalLight.transform = $Camera.transform
