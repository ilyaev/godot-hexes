extends "base.gd"

func _init():
    name = "SELECTED_SOURCE"


func region_selectable(region):
    return region.links.has(index.source_selection_id)

func on_exit():
    Arrow.hide()
    if index.source_selection_id > 0:
        index.source_selection.deselect()
        index.source_selection_id = -1
    if index.target_selection_id > 0:
        index.target_selection.deselect()
        index.target_selection_id = -1

func process_input(event):
    if event is InputEventMouseButton:
        index.set_state(index.STATE_DEFAULT)
        pass

    if event is InputEventMouseMotion:

        var tip = arrow_collision(event)
        var mouse = mouse_collision(event)
        global.update_mouse_position(
            mouse.position,
            Camera.unproject_position(mouse.position)
        )

        Arrow.target_pos = mouse.position - Arrow.translation

        if tip:
            if tip.collider.has_method('select') and tip.collider.id != index.source_selection_id:
                if index.target_selection_id != tip.collider.id:
                    if index.target_selection_id > 0:
                        index.target_selection.deselect()
                    if region_selectable(tip.collider):
                        tip.collider.select()
                        index.target_selection = tip.collider
                        index.target_selection_id = index.target_selection.id
                    else:
                        index.target_selection = false
                        index.target_selection_id = -1
            else:
                if index.target_selection_id > 0:
                    index.target_selection.deselect()
                    index.target_selection_id = -1

