extends Node

const CMD_REGION_SELECT = 0
const CMD_SELECTION_ARROW_SHOW = 1

var index = preload('./command/index.gd').new()

func add(obj):
    index.add(obj)