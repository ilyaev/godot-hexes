extends "base.gd"

var camera_transform
const TILT_SPEED = 0.3

func _init():
    name = "SELECTED_SOURCE"


func region_selectable(region):
    return region.links.has(index.source_selection_id) && region.country_id != index.source_selection.country_id

func on_enter():
    .on_enter()
    camera_transform = Camera.transform

    commands.add({
        "id": commands.CMD_SELECTION_ARROW_SHOW,
        "region": index.source_selection,
        "position": global.mouse_position
    })

func on_exit():
    Arrow.hide()
    if index.source_selection_id > 0:
        commands.add({
            "id": commands.CMD_REGION_SELECT,
            "region": index.source_selection,
            "select": false
        })
        index.source_selection_id = -1
    if index.target_selection_id > 0:
        commands.add({
            "id": commands.CMD_REGION_SELECT,
            "region": index.target_selection,
            "select": false
        })
        index.target_selection_id = -1

func process_input(event):
    var result = []
    if event is InputEventMouseButton:
        if index.target_selection_id > 0:
            index.emit_signal("selected", index.source_selection, index.target_selection)
        else:
            index.emit_signal("wrong_selection")
        set_state(index.STATE_DEFAULT)
        return

    if event is InputEventMouseMotion:

        var tip = arrow_collision(event)
        var mouse = mouse_collision(event)

        if mouse:
            global.update_mouse_position(
                mouse.position,
                Camera.unproject_position(mouse.position)
            )
            Arrow.target_pos = mouse.position - Arrow.translation

        if tip:
            if tip.collider.has_method('select') and tip.collider.id != index.source_selection_id:
                if index.target_selection_id != tip.collider.id:
                    if index.target_selection_id > 0:
                        result.append({
                            "id": commands.CMD_REGION_SELECT,
                            "region": index.target_selection,
                            "select": false
                        })
                    if region_selectable(tip.collider):
                        result.append({
                            "id": commands.CMD_REGION_SELECT,
                            "region": tip.collider,
                            "select": true
                        })
                        index.target_selection = tip.collider
                        index.target_selection_id = index.target_selection.id
                    else:
                        index.target_selection = false
                        index.target_selection_id = -1
            else:
                if index.target_selection_id > 0:
                    result.append({
                        "id": commands.CMD_REGION_SELECT,
                        "region": index.target_selection,
                        "select": false
                    })
                    index.target_selection_id = -1
    return result

