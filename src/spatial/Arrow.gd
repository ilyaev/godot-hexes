extends Spatial

# public

var start_pos
var base_width = 0.5
var head_width = 0.3
var target_pos = Vector3(0,0,0) setget set_target_pos, get_target_pos
var color = Color('#ff0000') setget set_color, get_color
var z = 0
var base_angle = 0 setget set_base_angle, get_base_angle
var current_fixed_angle = 0

# private

var angle_step = PI / 4
var density = 10
var curve = Curve2D.new()
var mesh = Mesh.new()
var mat = SpatialMaterial.new()
var surface = global.Surface


func _ready():
	mat.set_albedo(Color('#ff0000'))
	$Mesh.set_material_override(mat)
	$Mesh.set_mesh(mesh)
	build()

func set_base_angle(new_angle):
	base_angle = new_angle

func get_base_angle():
	return base_angle

func set_target_pos(new_pos):
	target_pos = new_pos
	build()

func get_target_pos():
	return target_pos

func set_color(new_color):
	color = color
	mat.set_albedo(color)

func get_color():
	return color

func build():

	var start = Vector2(start_pos.x, start_pos.y)
	var end = Vector2(target_pos.x, target_pos.y)

	var angle = Vector2(0,1).angle_to(end - start)

	var fixed_angle = floor(angle / angle_step) * angle_step

	if angle < 0:
		fixed_angle = ceil(angle / angle_step) * angle_step

	if fixed_angle != current_fixed_angle:
		$Tween.stop_all()
		if current_fixed_angle == 0 or fixed_angle == 0 or sign(fixed_angle) == sign(current_fixed_angle):
			$Tween.interpolate_property(self, 'base_angle', base_angle, fixed_angle, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
			$Tween.start()
		else:
			base_angle = fixed_angle
		current_fixed_angle = fixed_angle

	var bottom_left = start - Vector2(base_width, 0).rotated(base_angle)
	var bottom_right = start + Vector2(base_width, 0).rotated(base_angle)

	var left_pinch = 1 / 2 - (angle - base_angle)
	var right_pinch = 1 / 2 + (angle - base_angle)

	var center = (end - start) / 2

	var right_center = center + ((bottom_right - start) * right_pinch).rotated(angle - base_angle)
	var left_center = center + ((bottom_left - start) * left_pinch).rotated(angle - base_angle)

	curve.clear_points()

	var head_shift_left = (bottom_left - start).rotated(angle - base_angle).normalized() * head_width / 2
	var head_shift_right = (bottom_right - start).rotated(angle - base_angle).normalized() * head_width / 2

	curve.add_point(bottom_left, Vector2(0,0), left_center - bottom_left)
	curve.add_point(end + head_shift_left)
	curve.add_point(end + head_shift_right)
	curve.add_point(bottom_right, right_center - bottom_right, Vector2(0,0))

	var points = [[],[]]

	for i in range(2):
		for n in range(density + 1):
			var offset = 1/(density + 0.0) * n
			var ii = i
			if i == 1:
				ii = 2
			var pos = curve.interpolate(ii, offset)
			points[i].push_back(Vector3(pos.x, pos.y, z))

	if mesh.get_surface_count() > 0:
		mesh.surface_remove(0)

	surface.clear()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)

	for i in range(density):
		var p1 = i
		var p2 = i + 1
		var p3 = density - p1
		var p4 = p3 - 1

		surface.add_vertex(points[0][p1])
		surface.add_vertex(points[0][p2])
		surface.add_vertex(points[1][p3])

		surface.add_vertex(points[0][p2])
		surface.add_vertex(points[1][p4])
		surface.add_vertex(points[1][p3])

		surface.add_vertex(tov3((end + head_shift_left * 1.6), z))
		surface.add_vertex(tov3((end * 1.4).rotated((angle - base_angle) * 0.15), z))
		surface.add_vertex(tov3((end + head_shift_right * 1.6), z))



	surface.generate_normals()
	surface.index()
	surface.commit(mesh)

func tov3(v2, z):
	return Vector3(v2.x, v2.y, z)

func _on_base_angle_change(object, key, elapsed, value):
	build()
