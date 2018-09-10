extends Node

const CMD_REGION_SELECT = 0
const CMD_SELECTION_ARROW_SHOW = 1
const CMD_SELECTION_ARROW_MOVE = 2
const CMD_START_ROUND = 3
# %%NEXT_ID:4%%

var index = preload('./command/index.gd').new()

func add(obj):
    index.add(obj)