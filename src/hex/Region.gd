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
var capital
var selected = false
var population = 0
var populations
var scene_populations = preload('../spatial/Populations.tscn')

func _ready():
	randomize()
	current_transform = transform
	original_transform = transform

	population = randi() % 7 + 1

	populations = scene_populations.instance()
	populations.transform = populations.transform.translated(capital.origin)
	populations.update(population)
	add_child(populations)
	pass

func set_population(new_population):
	population = new_population
	populations.update(population)

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
	if hex.is_capital:
		capital = hex

func set_mesh(mesh):
	color = Color(max(0.1,randf()),max(0.1,randf()),max(0.1,randf()),1)
	$Mesh.set_mesh(mesh)
	mat.set_albedo(color)
	$Mesh.set_material_override(mat)

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

func select():
	selected = true
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

func _on_HexRegion_mouse_entered():
	pass

func deselect():
	selected = false
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

func _on_HexRegion_mouse_exited():
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

func _on_HexRegion_input_event(camera, event, click_position, click_normal, shape_idx):
	if event.is_pressed():
		global.emit_signal("region_clicked", self, click_position)
