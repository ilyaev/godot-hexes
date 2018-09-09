extends "base.gd"

func _init():
    name = 'DEFAULT'

func on_enter():
    .on_enter()

func on_region_clicked(region, position):
    set_state(index.SELECTED_SOURCE)

func process_input(event):
    var results = []
    if event is InputEventMouseButton and event.is_pressed():
        var mouse = mouse_collision(event)
        if mouse:
            global.update_mouse_position(
                mouse.position,
                Camera.unproject_position(mouse.position)
            )
            if mouse.collider.has_method('select'):
                if index.source_selection_id != mouse.collider.id:
                    results.append({
                        "id": commands.CMD_REGION_SELECT,
                        "region": mouse.collider,
                        "select": true
                    })
                    if index.source_selection_id > 0:
                        results.append({
                            "id": commands.CMD_REGION_SELECT,
                            "region": index.source_selection,
                            "select": false
                        })
                index.source_selection = mouse.collider
                index.source_selection_id = index.source_selection.id
            else:
                if index.source_selection_id > 0:
                    results.append({
                        "id": commands.CMD_REGION_SELECT,
                        "region": index.source_selection,
                        "select": false
                    })
                    index.source_selection_id = -1

    return results

