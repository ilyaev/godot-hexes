extends Node

var game
var scene
var next_state = false
var index

func _init():
    name = 'BASE'

func on_enter():
    pass

func on_exit():
    pass

func set_state(new_state_id):
    index.set_state(new_state_id)

func process_input(event):
    pass

