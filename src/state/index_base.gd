extends Node

var state_classes = []
var scene
var state
var state_id
var state_stack = []

func _init():
    name = 'DEFAULT'

func _ready():
    for one in state_classes:
        add_child(one)

func set_state(new_state_id):
    if state and state.has_method("on_exit"):
        state.on_exit()

    state_id = new_state_id
    state = state_classes[state_id]
    state.scene = scene
    state.index = self
    state.on_enter()


func push_state():
    state_stack.push_front(state_id)

func pop_state():
    if state_stack.size() <= 0:
        return
    var next_id = state_stack[0]
    state_stack.pop_front()
    set_state(next_id)

func process_input(event):
    state.process_input(event)