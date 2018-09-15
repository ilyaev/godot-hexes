extends Node

const CMD_REGION_SELECT = 0
const CMD_SELECTION_ARROW_SHOW = 1
const CMD_SELECTION_ARROW_MOVE = 2
const CMD_START_ROUND = 3
const CMD_END_TURN = 4
# %%NEXT_ID:5%%

var index = preload('./command/index.gd').new()

func add(obj):
    index.add(obj)