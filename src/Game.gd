extends Spatial

var HexGrid_class = preload('res://src/hex/Grid.tscn')
var Grid
var prev_mouse_position = Vector3(0,0,0)
var original_transform
var free_look = false
var tween = Tween.new()
var region_selection = preload('./state/region_selection/index.gd').new()

func _ready():
	randomize()

	Grid = HexGrid_class.instance()
	Grid.build_all()
	add_child(Grid)

	add_child(tween)

	original_transform = $Camera.transform

	global.connect('region_clicked', region_selection, 'on_region_clicked')

	init_states()

	pass

func init_states():
	region_selection.scene = self
	add_child(region_selection)

func _input(event):

	region_selection.process_input(event)

	if event is InputEventKey:
		if Input.is_key_pressed(KEY_H):
			for region in Grid.get_node('Regions').get_children():
				if region.id == -1:
					if region.is_visible_in_tree():
						region.hide()
					else:
						region.show()
		if Input.is_key_pressed(KEY_R):
			remove_child(Grid)
			Grid = HexGrid_class.instance()
			Grid.build_all()
			add_child(Grid)

		if Input.is_key_pressed(KEY_W):
			tween.interpolate_property($Camera, 'transform', $Camera.transform, $Camera.transform.translated(Vector3(0,0,-0.3)), 0.2, Tween.TRANS_SINE, Tween.EASE_IN)
			tween.start()

		if Input.is_key_pressed(KEY_S):
			tween.interpolate_property($Camera, 'transform', $Camera.transform, $Camera.transform.translated(Vector3(0,0,0.3)), 0.2, Tween.TRANS_SINE, Tween.EASE_IN)
			tween.start()


	if Input.is_key_pressed(KEY_SPACE):
		if !free_look:
			prev_mouse_position.x = 0
		free_look = true
	else:
		if free_look:
			tween.interpolate_property($Camera, 'transform', $Camera.transform, original_transform, 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
			tween.start()


		free_look = false

	if free_look and event is InputEventMouseMotion:
		if prev_mouse_position.x == 0:
			prev_mouse_position = event.position
		var diff = event.position - prev_mouse_position
		$Camera.transform = original_transform.rotated(Vector3(0,1,0), PI / 2 * diff.x / 300).rotated(Vector3(1,0,0), PI / 2 * diff.y / 300)

