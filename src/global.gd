extends Node

var mode = 'dev'
var _start_time = 0
var MeshTool = MeshDataTool.new()
var Surface = SurfaceTool.new()
var pow_nom = 0

func start_profile():
	_start_time = OS.get_ticks_msec()

func print_profile(caption = "TS"):
    print(caption, ': ', OS.get_ticks_msec() - _start_time)
    _start_time = OS.get_ticks_msec()

func end_profile():
    _start_time = 0

func round_vector(val, precision = 3):
    var result = Vector3(0,0,0)
    if !pow_nom:
        pow_nom = pow(10, precision)
    result.x = round(val.x * pow_nom) / pow_nom
    result.y = round(val.y * pow_nom) / pow_nom
    result.z = round(val.z * pow_nom) / pow_nom
    return result