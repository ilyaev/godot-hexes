extends Area

var id = -1
var original_id = -1
var country_id = -1
var links = []
var hexes = []
var mat = SpatialMaterial.new()
var rotation_speed = 0
var color
var current_transform
var original_transform
var selection_shift = 0.1

func _ready():
	current_transform = transform
	original_transform = transform
	pass

func set_country(country):
	country_id = country

func set_color(new_color):
	color = new_color
	mat.set_albedo(color)

func add_links(new_links):
	for link in new_links:
		if !links.has(link):
			links.push_back(link)

func add_hex(hex):
	hexes.push_back(hex)

func set_mesh(mesh):
	color = Color(max(0.1,randf()),max(0.1,randf()),max(0.1,randf()),1)
	$Mesh.set_mesh(mesh)
	mat.set_albedo(color)
	# mat.flags_transparent = 1
	$Mesh.set_material_override(mat)



	# gravity_scale = 0.1
	# bounce = randf()
	# set_axis_velocity(Vector3(randf()-0.5, randf()-0.5, randf()-0.5) / 2)
	# apply_impulse(Vector3(0,0,0), Vector3(randf()-0.5, randf()-0.5, randf()-0.5))


	# Create Collision Shape
	var tool = global.MeshTool
	tool.create_from_surface(mesh, 0)

	var faces = []
	for idx in range(0, tool.get_face_count()):
		faces.push_back(tool.get_vertex(tool.get_face_vertex(idx, 0)))
		faces.push_back(tool.get_vertex(tool.get_face_vertex(idx, 1)))
		faces.push_back(tool.get_vertex(tool.get_face_vertex(idx, 2)))

	var shape = ConcavePolygonShape.new()
	shape.set_faces(PoolVector3Array(faces))

	$Shape.set_shape(shape)

	tool.clear()


func _physics_process(delta):
	return
	if rotation_speed > 0:
		rotate_x(delta * PI / rotation_speed)
		rotate_y(delta * PI / rotation_speed)
		rotate_z(delta * PI / rotation_speed)

func _on_HexRegion_mouse_entered():
	$Tween.interpolate_property(
		self,
		'transform',
		transform,
		current_transform.translated(Vector3(0, 0, selection_shift)),
		0.2,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)
	current_transform = current_transform.translated(Vector3(0,0,selection_shift))
	$Tween.start()
	pass



func _on_HexRegion_mouse_exited():
	$Tween.interpolate_property(
		self,
		'transform',
		transform,
		current_transform.translated(Vector3(0, 0, -selection_shift)),
		0.2,
		Tween.TRANS_SINE,
		Tween.EASE_IN
	)
	current_transform = current_transform.translated(Vector3(0, 0, -selection_shift))
	$Tween.start()
	pass


func get_reachability(map, region_id, result):
	for link in map[region_id]:
		if !result.has(link) and map.has(link):
			result.push_back(link)
			get_reachability(map, link, result)
	return result

func is_reachable(traverse_map):
	var result = true
	var traverse = get_reachability(traverse_map, id, [])
	return traverse.size() == traverse_map.size()