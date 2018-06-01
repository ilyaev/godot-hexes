extends Spatial

var hex_class = preload("Cell.tscn")
var region_class = preload("Region.tscn")
var outline_class = preload("Outline.tscn")

var cols = 40
var rows = 32
var regions_count = round(cols * rows / 23)
var voids_count = round(regions_count * 0.3)
var country_count = 5

var size = 0.05
var height = -0.1
var vert_hex = {}
var vertice_hash_map = {}
var hex_width = size * sqrt(3)
var hex_height = 2 * size
var offset_y = hex_height * 3/4
var outline_vertices = []
var outline_triangles = []
var region_hexes = {}
var capitals = []
var _hex_dict = {}
var traverse_map = {}
var oddr_directions = [
    [[+1,  0], [ 0, -1], [-1, -1],
     [-1,  0], [-1, +1], [ 0, +1]],
    [[+1,  0], [+1, -1], [ 0, -1],
     [-1,  0], [ 0, +1], [+1, +1]],
]

var oddr_directions_alternate = [
	[[0, -1],[1,0],[0,1],[-1,1],[-1,0],[-1,-1]],
	[[1,-1],[1,0],[1,1],[0,1],[-1,0],[0,-1]]
]

var Outline

var color_map = [
	Color(0,0,0),
	Color("#b3ff01"),
	Color("#b37ffe"),
	Color("#009302"),
	Color("#ff7ffe"),
	Color("#ff7f02"),
	Color("#b2fffe"),
	Color("#ffff02"),
	Color("#ff5858")
]


func _ready():
	randomize()
	global.start_profile()
	build_hexes()
	global.print_profile('Buld Hexes - ' + str(rows * cols))
	plant_capitals()
	global.print_profile('Plant Capitals')
	build_borders()
	global.print_profile('Build Borders')
	build_regions()
	global.print_profile('Build Regions')
	create_voids()
	global.print_profile('Create Voids')
	plant_countries()
	global.print_profile('Plant Countries')
	build_visual_outline()
	global.print_profile('Build Outline')
	cleanup()
	global.print_profile('Cleanup')
	translate_object_local(Vector3(-cols * hex_width / 2, rows * offset_y / 2, 0))




func build_visual_outline():
	var coords = {
		0: [],
		1: [],
		2: []
	}

	var radius = size

	var step = 2 * PI / 6
	var offset = 0
	var shift = radius / 13

	for n in range(6):
		var sinx = sin(offset + step * n)
		var cosy = cos(offset + step * n)
		coords[0].push_back(Vector3(radius * sinx, radius * cosy, 0.0001))
		coords[1].push_back(Vector3((radius + shift) * sinx, (radius + shift) * cosy, 0.001))
		coords[2].push_back(Vector3((radius - shift) * sinx, (radius - shift) * cosy, 0.001))

	Outline = outline_class.instance()

	for region in $Regions.get_children():
		var prev_index = -10
		for hex in region.hexes:
			var parity = hex.row & 1
			var dirs = oddr_directions_alternate[parity]

			for index in range(6):

				var direction = dirs[index]
				var target = get_hex_by_hash(gen_hex_hash(hex.row + direction[1], hex.col + direction[0]))

				if target.region_id != hex.region_id and (target.region_id >= 0 or hex.region_id >= 0):
					var next_index = index + 1
					if next_index == 6:
						next_index = 0
					Outline.add_segment([
						global.round_vector(coords[1][index] + hex.origin),
						global.round_vector(coords[1][next_index] + hex.origin),
						global.round_vector(coords[2][next_index] + hex.origin),
						global.round_vector(coords[2][index] + hex.origin),
					])
					prev_index = index

	add_child(Outline)

	pass

func plant_countries():
	var pool = []
	var exist = {}

	var per_country = ceil(regions_count / country_count)

	for n in range(country_count):
		pool.push_back(n+1)

	for region in $Regions.get_children():
		if region.id >= 0:
			region.set_country(pool[randi() % pool.size()])
			region.set_color(color_map[region.country_id])
			if !exist.has(region.country_id):
				exist[region.country_id] = 0
			exist[region.country_id] += 1
			if exist[region.country_id] >= per_country:
				pool.erase(region.country_id)

	pass

func create_voids():

	var per_country = ceil((regions_count - voids_count) / country_count)
	voids_count = regions_count - per_country * country_count

	for n in range(voids_count):
		var flag = true
		while flag:
			var target_region = $Regions.get_children()[randi() % $Regions.get_children().size()]

			build_traverse_map(target_region.id)

			var reachable = target_region.id >= 0

			if reachable:
				for region in $Regions.get_children():
					if target_region.id != region.id and region.id >= 0 and target_region.id >=0 and !region.is_reachable(traverse_map):
						reachable = false
						break

			if reachable:
				# $Regions.remove_child(target_region)
				target_region.hide()
				target_region.original_id = target_region.id
				target_region.id = -1
				for rhex in target_region.hexes:
					rhex.region_id = -1
				# target_region.queue_free()
				flag = false
				regions_count -= 1
			else:
				flag = true


		pass

func cleanup():
	_hex_dict.clear()
	outline_vertices.clear()
	outline_triangles.clear()
	region_hexes.clear()
	capitals.clear()

	for region in $Regions.get_children():
		if region.id < 0:
			for hex in region.hexes:
				hex.queue_free()
			region.queue_free()

func build_regions():
	var regions = {}
	for row in range(rows):
		for col in range(cols):
			var hex = get_hex_by_hash(gen_hex_hash(row, col)) # [row,col,str(row) + str(col)].hash())
			if hex.id:
				if !regions.has(hex.region_id):
					regions[hex.region_id] = region_class.instance()
					regions[hex.region_id].id = hex.region_id
				regions[hex.region_id].add_hex(hex)
				regions[hex.region_id].add_links(get_hex_links(hex))

	for region_id in regions:
		if randf() > -1:
			var region = regions[region_id]
			var region_vertices = build_outline(region.hexes)
			var region_triangles = build_shape(region_vertices)
			var region_mesh = build_surface(region_vertices, region_triangles)

			regions[region_id].set_mesh(region_mesh)
			regions[region_id].rotation_speed = region_id / 2

			$Regions.add_child(regions[region_id])


func plant_capitals():
	for i in range(regions_count):
		var hex = get_random_empty_hex()
		hex.populate(i + 1, true)
		capitals.push_back(hex)
	pass

func build_borders():
	for row in range(rows):
		for col in range(cols):
			var hex = get_hex_by_hash(gen_hex_hash(row, col)) #[row,col,str(row) + str(col)].hash())
			if hex.id and !hex.is_capital:
				var capital
				var max_distance = 100000
				for capital_hex in capitals:
					var distance = capital_hex.distance_to(hex)
					if distance < max_distance:
						max_distance = distance
						capital = capital_hex

				hex.populate(capital.region_id)
				hex.mat.set_albedo(capital.mat.get_albedo() * 1.1)

				if !region_hexes.has(capital.region_id):
					region_hexes[capital.region_id] = []

				region_hexes[capital.region_id].push_back(hex)

	pass

func get_random_empty_hex():
	var flag = true
	var iteration = 0
	var hex

	while flag:
		iteration = iteration + 1
		if iteration > 1000:
			break

		var row = randi() % (rows - 2) + 1
		var col = randi() % (cols - 2) + 1

		hex = get_hex(row, col)

		if hex.id and hex.region_id == 0 and !hex.is_capital:
			flag = false
			for capital_hex in capitals:
				if capital_hex.distance_to(hex) <= 3 :
					flag = true

	return hex

func _physics_process(delta):
	# rotate_y(delta * PI)
	# rotate_x(delta * PI / 10)
	pass

func build_surface(region_vertices = outline_vertices, region_triangles = outline_triangles):

	var mesh = Mesh.new()

	var surface = global.Surface

	surface.clear()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)

	var back_vertices = []
	for vertice in region_vertices:
		back_vertices.push_back(vertice + Vector3(0, 0, height))

	for triangle in region_triangles:
		surface.add_vertex(region_vertices[triangle[0]])
		surface.add_vertex(region_vertices[triangle[1]])
		surface.add_vertex(region_vertices[triangle[2]])

		surface.add_vertex(back_vertices[triangle[0]])
		surface.add_vertex(back_vertices[triangle[2]])
		surface.add_vertex(back_vertices[triangle[1]])

	for n in range(region_vertices.size()):
		var next = n + 1
		if next == region_vertices.size():
			next = 0

		surface.add_vertex(region_vertices[n])
		surface.add_vertex(back_vertices[n])
		surface.add_vertex(back_vertices[next])

		surface.add_vertex(region_vertices[n])
		surface.add_vertex(back_vertices[next])
		surface.add_vertex(region_vertices[next])


	surface.generate_normals()
	surface.index()

	surface.commit(mesh)

	return mesh

func get_next_index(index):
	if index == 5:
		return 0
	else:
		return index + 1

func get_next_hex(hash_value, hexes):
	for i in hexes.size():
		if hexes[i] != hash_value:
			return hexes[i]
	return hash_value

func get_hex(row, col):
	var childs = $Hexes.get_children()
	for i in childs.size():
		if childs[i].row == row and childs[i].col == col:
			return childs[i]
	return {"region_id": -1, "is_capital": false, "id": 0}

func get_hex_by_hash(hash_value):
	if _hex_dict.has(hash_value):
		return _hex_dict[hash_value]
	var childs = $Hexes.get_children()
	for i in childs.size():
		if childs[i].id == hash_value:
			_hex_dict[hash_value] = childs[i]
			return childs[i]
	return {"region_id": -1, "is_capital": false, "id": 0}

func build_outline(hexes = $Hexes.get_children()):
	var index = 0
	var hex = hexes[index]
	var vertex_hash = hex.vert_hashes[index]
	var first_hash = vertex_hash

	var all_vertices = []

	for n in range(hexes.size() * 6):

		var vertex_hex_adjusted = []
		for v_hash in vert_hex[vertex_hash]:
			if get_hex_by_hash(v_hash).region_id == hex.region_id:
				vertex_hex_adjusted.push_back(v_hash)

		var hexes_per_vertex = vertex_hex_adjusted.size()
		if hexes_per_vertex == 1:
			all_vertices.append(hex.vertices[index])
			index = get_next_index(index)
			vertex_hash = hex.vert_hashes[index]
		elif hexes_per_vertex == 2:
			all_vertices.append(hex.vertices[index])
			hex = get_hex_by_hash(get_next_hex(hex.id, vertex_hex_adjusted))
			index = get_next_index(hex.get_vertice_index_by_hash(vertex_hash))
			vertex_hash = hex.vert_hashes[index]

		if vertex_hash == first_hash:
			break


	outline_vertices = all_vertices
	return all_vertices


func get_triangle_indexes_by_ear(index, vertices):
	var n = vertices.find(index)

	var next = n + 1
	if next >= vertices.size():
		next = 0

	var prev =  n - 1
	if prev < 0:
		prev = vertices.size() - 1

	return [index, vertices[next], vertices[prev]]

func get_triangle_by_ear(index, vertices):

	var indexes = get_triangle_indexes_by_ear(index, vertices)

	var points = [
		outline_vertices[index], outline_vertices[indexes[1]], outline_vertices[indexes[2]]
	]

	return points

func build_shape(region_vertices = outline_vertices):
	var ears = []
	var convexes = []
	var reflexes = []
	var vertices = []

	for n in region_vertices.size():
		vertices.push_back(n)

	# Build reflexes and convexes
	for n in region_vertices.size():
		var points = get_triangle_by_ear(n, vertices)

		var v1 = points[0] - points[1]
		var v2 = points[2] - points[0]

		if v1.cross(v2).z > 0:
			convexes.push_back(n)
		else:
			reflexes.push_back(n)

	# Build ears
	for n in range(region_vertices.size()):
		if convexes.has(n):
			if is_triangle_ear(get_triangle_indexes_by_ear(n, vertices), reflexes):
				ears.push_back(n)

	var all_triangles = []

	for n in range(region_vertices.size() * 2):
		if ears.size() <= 0:
			break
		var point = ears.pop_front()
		var points = get_triangle_indexes_by_ear(point, vertices)

		all_triangles.push_back(get_triangle_indexes_by_ear(point, vertices))

		vertices.erase(point)
		reflexes.erase(point)
		convexes.erase(point)

		for i in [points[1], points[2]]:
			var i_vertices = get_triangle_by_ear(i, vertices)
			var v1 = i_vertices[0] - i_vertices[1]
			var v2 = i_vertices[2] - i_vertices[0]
			if v1.cross(v2).z > 0:
				if !convexes.has(i):
					convexes.push_back(i)
					reflexes.erase(i)
			else:
				if !reflexes.has(i):
					reflexes.push_back(i)
					convexes.erase(i)

		for i in [points[1], points[2]]:
			var i_points = get_triangle_indexes_by_ear(i, vertices)
			if !reflexes.has(i) and is_triangle_ear(i_points, reflexes):
				if !ears.has(i):
					ears.push_front(i)
			else:
				if ears.has(i):
					ears.erase(i)

	outline_triangles = all_triangles
	return all_triangles


func is_triangle_ear(points, reflexes):
	var is_ear = true
	var triangle = [
		outline_vertices[points[0]],
		outline_vertices[points[1]],
		outline_vertices[points[2]]
	]
	for reflex in reflexes:
		if !points.has(reflex):
			if point_in_triangle(outline_vertices[reflex], triangle):
				is_ear = false
				break
	return is_ear


func build_hexes():
	for row in range(rows):
		var row_offset = 0
		if row % 2 != 0:
			row_offset = hex_width / 2
		for col in range(cols):
			if randi() % 20 > -1:
				var hex = hex_class.instance()
				var offset = Vector3(row_offset + hex_width * col, -1 * row * offset_y, 0)

				hex.row = row
				hex.col = col
				hex.radius = size
				hex.height = -size / 5
				hex.id = gen_hex_hash(row, col) #[row,col,str(row) + str(col)].hash()

				$Hexes.add_child(hex)
				hex.hide()

				hex.add_offset(offset)

				add_vertices_to_map(hex.vertices, hex.id)

func add_vertices_to_map(items, id):
	for n in items.size():
		var key = [items[n].x, items[n].y, items[n].z].hash()
		if !vertice_hash_map.has(key):
			vertice_hash_map[key] = items[n]
		if !vert_hex.has(key):
			vert_hex[key] = []
		vert_hex[key].append(id)


func point_in_triangle(point, vertices):
	var x_min = min(vertices[0].x, min(vertices[1].x, vertices[2].x))
	var x_max = max(vertices[0].x, max(vertices[1].x, vertices[2].x))
	var y_min = min(vertices[0].y, min(vertices[1].y, vertices[2].y))
	var y_max = max(vertices[0].y, max(vertices[1].y, vertices[2].y))

	if point.x < x_min or point.x > x_max or point.y < y_min or point.y > y_max:
		return false


	var side1 = calc_b_side(vertices[0].x, vertices[0].y, vertices[1].x, vertices[1].y, point.x, point.y)
	var side2 = calc_b_side(vertices[1].x, vertices[1].y, vertices[2].x, vertices[2].y, point.x, point.y)
	var side3 = calc_b_side(vertices[2].x, vertices[2].y, vertices[0].x, vertices[0].y, point.x, point.y)

	if side1 >=0 and side2 >=0 and side3 >=0:
		return true

	return false

func calc_b_side(x1, y1, x2, y2, x, y):
	return (y2 - y1) * (x - x1) + (-x2 + x1) * (y - y1)


func get_hex_links(src):
	var parity = src.row & 1
	var dirs = oddr_directions[parity]
	var result = []

	for direction in dirs:
		var hex = get_hex_by_hash(gen_hex_hash(src.row + direction[0], src.col + direction[1]))
		if hex.id and hex.region_id != src.region_id and !result.has(hex.region_id):
			result.push_back(hex.region_id)

	return result

func build_traverse_map(exclude_region_id = -1):
	traverse_map.clear()
	for region in $Regions.get_children():
		if !traverse_map.has(region.id) and region.id != exclude_region_id and region.id >= 0:
			traverse_map[region.id] = region.links


func gen_hex_hash(row, col):
	var result = str([row, col].hash()) + str(row) + str(col)
	return int(result)