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
	# rotate_y(delta * PI * speed)
	# rotate_x(delta * PI * speed)
	# rotate_z(delta * PI * speed)
	hide()
	pass

func build_material():
	mat.set_albedo(Color(0,max(0.5,randf()),0,1))


func build_shape(density = 6):
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
		var x = radius * sin(offset + step * n)
		var y = radius * cos(offset + step * n)
		verts[n] = Vector3(x,y,0)
		verts2[n] = verts[n] + Vector3(0,0,height)

	for n in range(density - 2):
		surface.add_vertex(verts[0])
		surface.add_vertex(verts[n + 1])
		surface.add_vertex(verts[n + 2])

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
	vert_hashes.resize(vertices.size())
	for n in range(vertices.size()):
		vertices[n] = round_vector(vertices[n] + offset, 3)
		vert_hashes[n] = [vertices[n].x, vertices[n].y, vertices[n].z].hash()
	translate(round_vector(offset, 3))

func round_vector(val, precision = 3):
	var result = Vector3(0,0,0)
	var nom = pow(10, precision)
	result.x = round(val.x * nom) / nom
	result.y = round(val.y * nom) / nom
	result.z = round(val.z * nom) / nom
	return result

func populate(country, flag = false):
	region_id = country
	is_capital = flag
	if flag:
		mat.set_albedo(Color(0,max(0.4,randf()),0,1))

func distance_to(hex):
	var result = (abs(hex.x - x) + abs(hex.y - y) + abs(hex.z - z)) / 2
	return result
