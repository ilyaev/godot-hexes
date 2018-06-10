extends Spatial

var dummy_class = preload('Dummy.tscn')
var arrow_class = preload('../spatial/arrow.tscn')
var curve = Curve2D.new()
var target_picked = false
var center_picked = false
var original_transform
var pointer

func _ready():
	randomize()
	original_transform = $Target.transform
	$Target.translate(Vector3(0,1,0))
	# arrow()

	pointer = arrow_class.instance()
	pointer.start_pos = Vector3(0,0,0)
	pointer.target_pos = Vector3(0,1,0)

	add_child(pointer)


func add_sphere(pos, color = '#00ff00'):
	var dummy = dummy_class.instance()
	var mat = SpatialMaterial.new()
	mat.set_albedo(Color(color))
	dummy.get_node('Mesh').set_material_override(mat)
	dummy.translate(Vector3(pos.x, pos.y, 0))
	$Lines.add_child(dummy)

func arrow():
	clear_lines()

	var angle_step = PI / 4

	var target_pos = $Target.translation
	var start = Vector2(0,0)
	var end = Vector2(target_pos.x, target_pos.y)

	var angle = Vector2(0,1).angle_to(end - start)

	var fixed_angle = floor(angle / angle_step) * angle_step

	if angle < 0:
		fixed_angle = ceil(angle / angle_step) * angle_step

	var bottom_width = 0.5
	var bottom_left = start - Vector2(bottom_width, 0).rotated(fixed_angle)
	var bottom_right = start + Vector2(bottom_width, 0).rotated(fixed_angle)

	draw_line(start, end)
	draw_line(start, bottom_left, 5)
	draw_line(start, bottom_right, 5)
	draw_line(bottom_left, end)
	draw_line(bottom_right, end)



	var center = (end - start) / 2
	var right_center = center + ((bottom_right - start) * 1.2).rotated(angle - fixed_angle)
	var left_center = center + ((bottom_left - start) / 4).rotated(angle - fixed_angle)

	if angle < 0:
		right_center = center + ((bottom_right - start) / 4).rotated(angle - fixed_angle)
		left_center = center + ((bottom_left - start) * 1.2).rotated(angle - fixed_angle)



	draw_line(center, left_center)
	draw_line(center, right_center)

	curve.clear_points()

	curve.add_point(bottom_left, Vector2(0,0), left_center - bottom_left)
	curve.add_point(end)
	curve.add_point(bottom_right, right_center - bottom_right, Vector2(0,0))

	var cdenst = 20

	for i in range(3 - 1):
		for n in range(cdenst):
			var offset = 1/20.0 * n
			var pos = curve.interpolate(i, offset)
			add_sphere(Vector3(pos.x, pos.y, 0), '#ff0000')


func draw_line(start_pos, end_pos, density = 10):
	var step = (end_pos - start_pos) / density
	for n in (density + 1):
		add_sphere(start_pos + step * n)


func clear_lines():
	for one in $Lines.get_children():
		one.queue_free()

func _on_Target_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			target_picked = !target_picked
			if target_picked:
				$Target/Shape.disabled = true


func _input(event):
	if event is InputEventMouseButton and !event.is_pressed() and target_picked:
		target_picked = false
		$Target/Shape.disabled = false

	if event is InputEventMouseMotion and target_picked:
		var mouse_pos = event.position
		var space_state = get_world().get_direct_space_state()
		var from = $Camera.project_ray_origin(mouse_pos)
		var to = from + $Camera.project_ray_normal(mouse_pos) * 10000

		var result = space_state.intersect_ray( from, to )
		if result:
			$Target.transform = original_transform.translated(Vector3(result.position.x, result.position.y, 0))
			# arrow()
			pointer.target_pos = result.position

	if event is InputEventMouseButton and !event.is_pressed() and center_picked:
		center_picked = false
		$Center/Shape.disabled = false

	if event is InputEventMouseMotion and center_picked:
		var mouse_pos = event.position
		var space_state = get_world().get_direct_space_state()
		var from = $Camera.project_ray_origin(mouse_pos)
		var to = from + $Camera.project_ray_normal(mouse_pos) * 10000

		var result = space_state.intersect_ray( from, to )
		if result:
			$Center.transform = original_transform.translated(Vector3(result.position.x, result.position.y, 0))
			# arrow()
			pointer.start_pos = result.position
			pointer.build()



func _on_Center_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			center_picked = !center_picked
			if center_picked:
				$Center/Shape.disabled = true
