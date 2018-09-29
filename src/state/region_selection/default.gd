extends "base.gd"

func _init():
    name = 'DEFAULT'

func on_enter():
    .on_enter()

func on_region_clicked(region, position):
    if region.get_player() == index.scene.get_active_player():
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
            if mouse.collider.has_method('select') && mouse.collider.get_player() == index.scene.get_active_player():
                results.append({
                    "id": commands.CMD_SELECT_SOURCE_REGION,
                    "region": mouse.collider
                })

    return results

