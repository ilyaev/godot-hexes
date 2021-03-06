var hexes = []
var radius = 0
var density = 6
var _hex_dict = {}
var _hex_coord_dict = {}

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


func add_hex(row, col, offset):
    var hex = blank_hex(row, col, offset)

    hex.vertices.resize(density)
    hex.vert_hashes.resize(density)

    var step = 2 * PI / density

    for n in range(density):
        var x = radius * sin(step * n)
        var y = radius * cos(step * n)
        hex.vertices[n] = global.round_vector(Vector3(x, y, 0) + offset)
        hex.vert_hashes[n] = [hex.vertices[n].x, hex.vertices[n].y, hex.vertices[n].z].hash()

    hexes.push_back(hex)

    _hex_dict[hex.id] = hex
    if !_hex_coord_dict.has(hex.row):
        _hex_coord_dict[hex.row] = {}
    _hex_coord_dict[hex.row][hex.col] = hex

    return hex

func blank_hex(row, col, offset):
    var result = {
        "x": col - (row - (row&1)) / 2,
        "y": 0,
        "z": row,
        "row": row,
        "col": col,
        "vertices": [],
        "vert_hashes": [],
        "id": gen_hex_hash(row, col),
        "region_id": 0,
        "is_capital": false,
        "origin": offset
    }

    result.y = -result.x - result.z
    # result.q = result.x
    # result.r = result.z
    # result.pos = Vector3(result.x, result.y, result.z)
    return result

func gen_hex_hash(row, col):
    var result = str([row, col].hash()) + str(row) + str(col)
    return int(result)

func get_vertice_index_by_hash(hex, hash_value):
    for n in hex.vert_hashes.size():
        if hex.vert_hashes[n] == hash_value:
            return n
    return -1

func populate(hex, country, flag = false):
    hex.region_id = country
    hex.is_capital = flag

func distance_to(src, hex):
    var result = (abs(hex.x - src.x) + abs(hex.y - src.y) + abs(hex.z - src.z)) / 2
    return result

func get_hex(row, col):
    if _hex_coord_dict.has(row) and _hex_coord_dict[row].has(col):
        return _hex_coord_dict[row][col]
    return {"region_id": -1, "is_capital": false, "id": 0}

func get_hex_by_hash(hash_value):
    if _hex_dict.has(hash_value):
        return _hex_dict[hash_value]
    return {"region_id": -1, "is_capital": false, "id": 0}


func erase_cell(row, col):
    var hex = get_hex(row, col)
    hex.region_id = -2