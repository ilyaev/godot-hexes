extends './base.gd'

var position
var Arrow

func _init():
    name = 'ARROW_MOVE'

func set_params(params):
    position = params.position
    Arrow = scene.get_node('Arrow')

func execute():
    Arrow.target_pos = position - Arrow.translation