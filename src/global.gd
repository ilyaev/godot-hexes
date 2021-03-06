extends Node

const DEBUG = {
    "commands": true,
    "states": true
}

const REGION_HIGHLIGHT_COLOR = Color(1, 0, 0)

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

var mode = 'dev'
var _start_time = 0
var MeshTool = MeshDataTool.new()
var Surface = SurfaceTool.new()
var pow_nom = 0
var mouse_position = Vector3(0, 0, 0)
var mouse_screen_position = Vector3(0, 0, 0)


signal region_clicked
signal mouse_move

func start_profile():
	_start_time = OS.get_ticks_msec()

func print_profile(caption = "TS"):
    print(caption, ': ', OS.get_ticks_msec() - _start_time)
    _start_time = OS.get_ticks_msec()

func end_profile():
    _start_time = 0

func get_player_color(index):
    return color_map[index + 1]

func round_vector(val, precision = 3):
    var result = Vector3(0,0,0)
    if !pow_nom:
        pow_nom = pow(10, precision)
    result.x = round(val.x * pow_nom) / pow_nom
    result.y = round(val.y * pow_nom) / pow_nom
    result.z = round(val.z * pow_nom) / pow_nom
    return result

func update_mouse_position(pos, s_pos):
    mouse_position = pos
    mouse_screen_position = s_pos
    emit_signal('mouse_move', pos, s_pos)