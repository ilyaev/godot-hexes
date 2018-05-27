extends Node

var mode = 'dev'
var _start_time = 0

func start_profile():
	_start_time = OS.get_ticks_msec()

func print_profile(caption = "TS"):
    print(caption, ': ', OS.get_ticks_msec() - _start_time)
    _start_time = OS.get_ticks_msec()

func end_profile():
    _start_time = 0