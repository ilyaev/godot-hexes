extends Spatial

var HexGrid_class = preload('res://src/hex/Grid.tscn')
var Grid
var prev_mouse_position = Vector3(0,0,0)
var original_transform
var free_look = false
var tween = Tween.new()
var light_tween = Tween.new()
var sp_transform

func _ready():
	randomize()

	sp_transform = $Sphere.transform

	Grid = HexGrid_class.instance()
	Grid.build_all()
	add_child(Grid)

	add_child(tween)
	add_child(light_tween)

	original_transform = $Camera.transform

	global.connect('region_clicked', self, 'on_region_clicked')

	pass

func on_region_clicked(region, position):
	$Arrow.relocate(region.capital.origin + Grid.translation)
	$Arrow.target_pos = position - $Arrow.translation
	$Arrow.build()
	$Arrow.show()

func _input(event):

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

	if event is InputEventMouseMotion:
		var mouse_pos = event.position
		var space_state = get_world().get_direct_space_state()
		var from = $Camera.project_ray_origin(mouse_pos)
		var to = from + $Camera.project_ray_normal(mouse_pos) * 10000

		var result = space_state.intersect_ray( from, to )
		if result:
			$Sphere.transform = sp_transform.translated(Vector3(result.position.x, result.position.y, result.position.z + 0.01))
			global.update_mouse_position(result.position, $Camera.unproject_position(result.position))
			$Arrow.target_pos = result.position - $Arrow.translation

