extends Spatial

var replay = []
var matrix
var dummy_class = preload('Dummy.tscn')
var speed = 0.01
var density = 32
var sections = 8
var x = 0
var last_y = 0
var prev_mouse_position = Vector3(0,0,0)
var original_transform
var free_look = false
var tween = Tween.new()
var surface = SurfaceTool.new()
var mesh = Mesh.new()
var all_points = []

export var stretch = 1 setget set_stretch, get_stretch
var stretch_min = 1
var stretch_max = 4
var stretch_duration = 2

var shift = 0
var shift_min = 0
var shift_max = 2*PI


func _ready():

	var Mesh = MeshInstance.new()
	Mesh.set_mesh(mesh)

	var mat = SpatialMaterial.new()
	mat.set_albedo(Color('#00ff00'))
	Mesh.set_material_override(mat)

	add_child(Mesh)

	$Center.hide()
	$Master.hide()
	original_transform = $Camera.transform

	add_child(tween)
	calc_arrow()

	$Tween2.interpolate_property(self, 'stretch', stretch, stretch_max, stretch_duration, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$Tween2.start()

	$Tween3.interpolate_property(self, 'shift', shift, shift_max, stretch_duration, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	$Tween3.start()

	pass

func set_stretch(value):
	stretch = value
	calc_arrow()

func _on_Tween2_tween_completed(object, key):
	if stretch >= stretch_max:
		$Tween2.interpolate_property(self, 'stretch', stretch, stretch_min, stretch_duration, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		$Tween2.start()

		$Tween3.interpolate_property(self, 'shift', shift, shift_min, stretch_duration, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		$Tween3.start()

	elif stretch <= stretch_min:
		$Tween2.interpolate_property(self, 'stretch', stretch, stretch_max, stretch_duration, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		$Tween2.start()

		$Tween3.interpolate_property(self, 'shift', shift, shift_max, stretch_duration, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		$Tween3.start()

func get_stretch():
	return stretch


func calc_arrow():

	var x_start = -PI * 0.5
	var size = PI * 2 * 0.5

	# var x_start = -1
	# var size = 5

	var step = size / density

	var points = []


	for n in range(density + 1):
		var x = x_start + step * n
		var y = 0
		# y = log(abs(x+0.00000001))
		# y = x * x * x + 0.5
		# y = sin(1 / (sqrt(abs(x)) + 0.00001))
		# y = 1 / sqrt(x) / cos(x-1)

		# y = cos(x*x + shift) + 2.0 # blob

		y = cos(x*x + shift) + 2.0

		var next = Vector3(x/stretch, y/3, 0)
		add_sphere(next, '#00aa00')

		var ref = next.reflect(Vector3(1,0,0))
		add_sphere(ref, '#aa0000')

		for i in range(sections):
			var angle = PI * 2 / sections * i
			var po = next.rotated(Vector3(1,0,0), angle)
			if !points.has(i):
				points.push_back([])
			if !points[i].has(n):
				points[i].push_back([])
			points[i][n] = po
			add_sphere(po, '#AAAAAA')

	all_points = points
	build_shape_from_points()

func build_shape_from_points(points = all_points):
	if mesh.get_surface_count() > 0:
		mesh.surface_remove(0)
	surface.clear()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)


	for section in range(sections):
		var next = section + 1
		if next == sections:
			next = 0
		for n in range(points[section].size() - 1):
			surface.add_vertex(points[next][n+1])
			surface.add_vertex(points[next][n])
			surface.add_vertex(points[section][n])

			surface.add_vertex(points[section][n+1])
			surface.add_vertex(points[next][n+1])
			surface.add_vertex(points[section][n])


			surface.add_vertex(points[section][n])
			surface.add_vertex(points[next][n])
			surface.add_vertex(points[next][n+1])


			surface.add_vertex(points[section][n])
			surface.add_vertex(points[next][n+1])
			surface.add_vertex(points[section][n+1])


	surface.generate_normals()
	surface.index()

	surface.commit(mesh)

func _input(event):

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


func add_sphere(pos, color = '#00ff00'):
	return
	var dummy = dummy_class.instance()
	var mat = SpatialMaterial.new()
	mat.set_albedo(Color(color))
	dummy.get_node('Mesh').set_material_override(mat)
	dummy.translate(pos)
	add_child(dummy)
