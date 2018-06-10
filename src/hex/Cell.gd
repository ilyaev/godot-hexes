extends Area

var surface # = SurfaceTool.new()
var mat = SpatialMaterial.new()
var mesh = Mesh.new()
var radius = 0.5
var height = -0.5
var speed = 1
var row = 0
var col = 0
var q = 0
var r = 0
var x = 0
var y = 0
var z = 0
var pos
var vertices = []
var vert_hashes = []
var id = 0
var region_id = 0
var is_capital = false
var origin
var density = 6

func _ready():
	surface = global.Surface
	calculate_coordinates()
	build_shape()
	build_material()
	$Mesh.set_mesh(mesh)
	$Mesh.set_material_override(mat)

func calculate_coordinates():
	x = col - (row - (row&1)) / 2
	z = row
	y = -x-z
	q = x
	r = z
	pos = Vector3(x, y, z)

func _physics_process(delta):
	# rotate_y(delta * PI)
	# rotate_x(delta * PI * speed)
	# rotate_z(delta * PI * speed)
	# show()
	pass

func build_material():
	mat.set_albedo(Color(0,max(0.5,randf()),0,1))


func get_vertex(index, size):
	var step = 2 * PI / density
	var x = sin(step * index) * size
	var y = cos(step * index) * size
	return Vector3(x, y, 0)

func build_shape():
	if mesh.get_surface_count() > 0:
		mesh.surface_remove(0)
	surface.clear()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)

	var verts = []
	var verts2 = []
	verts.resize(density)
	verts2.resize(density)

	var step = 2 * PI / density
	var offset = PI / density
	offset = 0

	for n in range(density):
		var size = radius
		# if (n > 1 and n < 5) and size > 0.2:
		if n > 0 and size > 0.2:
			size = 0.2
		var x = size * sin(offset + step * n)
		var y = size * cos(offset + step * n)

		verts[n] = Vector3(x,y,0)
		verts2[n] = verts[n] + Vector3(0,0,height)

	for n in range(density - 2):
		surface.add_vertex(verts[0])
		surface.add_vertex(verts[n + 1])
		surface.add_vertex(verts[n + 2])

	for n in range(density - 2):
		surface.add_vertex(verts2[0])
		surface.add_vertex(verts2[density - n - 1])
		surface.add_vertex(verts2[density - n - 2])

	for n in range(density):
		var next = n + 1
		if next == density:
			next = 0
		surface.add_vertex(verts[n])
		surface.add_vertex(verts2[n])
		surface.add_vertex(verts2[next])

		surface.add_vertex(verts[n])
		surface.add_vertex(verts2[next])
		surface.add_vertex(verts[next])


	surface.generate_normals()
	surface.index()

	surface.commit(mesh)

	vertices = verts


func get_vertice_index_by_hash(hash_value):
	for n in vert_hashes.size():
		if vert_hashes[n] == hash_value:
			return n
	return -1

func add_offset(offset = Vector3(0,0,0)):
	origin = offset
	vert_hashes.resize(vertices.size())
	for n in range(vertices.size()):
		vertices[n] = global.round_vector(vertices[n] + offset, 3)
		vert_hashes[n] = [vertices[n].x, vertices[n].y, vertices[n].z].hash()
	translate(global.round_vector(offset, 3))

func populate(country, flag = false):
	region_id = country
	is_capital = flag
	if flag:
		mat.set_albedo(Color(0,max(0.4,randf()),0,1))

func distance_to(hex):
	var result = (abs(hex.x - x) + abs(hex.y - y) + abs(hex.z - z)) / 2
	return result

func update_size(new_size):
	radius = new_size
	build_shape()
	mat.set_albedo(Color(0, 0, 0, min(1, max(0, 1 - new_size / 10))))
	mat.flags_transparent = 1
	# return
	# var tool = global.MeshTool
	# print(radius, ', ', new_size)
	# tool.create_from_surface(mesh, 0)
	# for f in range(tool.get_face_count()):
	# 	if f < 10:
	# 		print('F: ', f, ' - ', tool.get_face_vertex(f, 0), ',',tool.get_face_vertex(f, 1), ',',tool.get_face_vertex(f, 2))
	# for n in [0,1,2,3,4]:
	# 	tool.set_vertex(n, get_vertex(n, new_size))

	# for s in range(mesh.get_surface_count()):
	# 	mesh.surface_remove(s)

	# tool.commit_to_surface(mesh)