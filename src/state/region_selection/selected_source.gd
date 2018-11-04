extends "base.gd"

var camera_transform

func _init():
    name = "SELECTED_SOURCE"


func on_enter():
    .on_enter()
    camera_transform = Camera.transform

func on_exit():
    var tmp_region = index.source_selection
    for link in index.links:
        link.deselect()
    index.links.clear()
    index.source_selection.deselect()
    index.source_selection.restore_color()
    index.source_selection_id = -1
    index.target_selection_id = -1
    index.source_selection = false
    index.target_selection = false
    if tmp_region:
        yield(tmp_region, "selection_finish")
    index.emit_signal("deselected")
    pass

func process_input(event):
    var result = []

    if event is InputEventMouseButton and event.is_pressed():
        var mouse = mouse_collision(event)
        if mouse.collider.has_method('select'):
            if mouse.collider.country_id == index.source_selection.country_id:
                result.append({
                    "id": commands.CMD_SELECT_SOURCE_REGION,
                    "region": mouse.collider
                })
            if index.links.has(mouse.collider):
                result.append({
                    "id": commands.CMD_SELECT_TARGET_REGION,
                    "region": mouse.collider
                })
    return result

