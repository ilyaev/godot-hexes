extends Node

const CMD_START_ROUND = 0
const CMD_END_TURN = 1
const CMD_SELECT_SOURCE_REGION = 2
const CMD_SELECT_TARGET_REGION = 3
# %%NEXT_ID:5%%

var index = preload('./command/index.gd').new()

func add(obj):
    index.add(obj)