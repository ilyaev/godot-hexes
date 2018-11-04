extends './base.gd'

var region

var selection_index

func _init():
   name = 'SELECT_TARGET_REGION'

func set_params(params):
    region = params.region
    selection_index = scene.region_selection

func execute():
    selection_index.target_selection = region
    selection_index.target_selection_id = region.id
    scene.turn.resolve_selection(selection_index.source_selection, selection_index.target_selection)
