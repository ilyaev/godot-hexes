extends Node

const CMD_REGION_SELECT = 0
const CMD_SELECTION_ARROW_SHOW = 1
const CMD_SELECTION_ARROW_MOVE = 2
const CMD_START_ROUND = 3
const CMD_END_TURN = 4
const CMD_SELECT_SOURCE_REGION = 5
const CMD_SELECT_TARGET_REGION = 6
# %%NEXT_ID:7%%

var index = preload('./command/index.gd').new()

func add(obj):
    index.add(obj)