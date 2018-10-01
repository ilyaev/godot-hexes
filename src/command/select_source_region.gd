extends './base.gd'

var region
var selection_index
var links

func _init():
   name = 'SELECT_SOURCE_REGION'

func set_params(params):
   region = params.region
   selection_index = scene.region_selection
   links = selection_index.links
   pass

func execute():
    var prev = selection_index.source_selection_id

    if prev >= 0:
        selection_index.source_selection.deselect()
        selection_index.source_selection.restore_color()

    selection_index.source_selection = region
    selection_index.source_selection_id = selection_index.source_selection.id
    region.select()
    region.highlight()

    if prev < 0:
        selection_index.set_state(selection_index.SELECTED_SOURCE)

    for link in selection_index.links:
        link.deselect()


    links.clear()
    for link_id in region.links:
        var link = scene.Grid.get_region(link_id)
        if link.id >= 0 and link.country_id != region.country_id:
            links.append(link)
            link.select()

    scene.turn.on_region_clicked(region)

    pass