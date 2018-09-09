extends './base.gd'

var region
var select

func _init():
    name = 'REGION_SELECT'

func set_params(params):
    region = params.region
    select = params.select

func execute():
    if select:
        region.select()
        scene.turn.on_region_clicked(region, global.mouse_position)
    else:
        region.deselect()