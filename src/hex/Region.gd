extends Area

var id = -1
var country_id = -1
var links = []
var hexes = []
var mat = SpatialMaterial.new()
var rotation_speed = 0
var color

func _ready():
	pass

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

	var tool = MeshDataTool.new()
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
	print('Mouse here! ', id)
	pass # replace with function body


func _on_HexRegion_mouse_exited():
	print('Mouse Out! ', id)
	pass # replace with function body
