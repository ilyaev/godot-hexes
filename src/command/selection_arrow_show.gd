extends './base.gd'

var region
var position
var Arrow

func _init():
    name = 'ARROW_SHOW'

func set_params(params):
    region = params.region
    position = params.position
    Arrow = scene.get_node('Arrow')

func execute():
    Arrow.relocate(region.capital.origin + scene.Grid.translation)
    Arrow.target_pos = position - Arrow.translation
    Arrow.build()
    Arrow.show()