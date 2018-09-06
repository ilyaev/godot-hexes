extends "base.gd"

func _init():
    name = 'DEFAULT'

func on_enter():
    .on_enter()

func on_region_clicked(region, position):
    Arrow.relocate(region.capital.origin + scene.Grid.translation)
    Arrow.target_pos = position - Arrow.translation
    Arrow.build()
    Arrow.show()
    index.set_state(index.SELECTED_SOURCE)

func process_input(event):
    if event is InputEventMouseMotion:
        var mouse = mouse_collision(event)
        if mouse:
            global.update_mouse_position(
                mouse.position,
                Camera.unproject_position(mouse.position)
            )
            if mouse.collider.has_method('select'):
                if index.source_selection_id != mouse.collider.id:
                    mouse.collider.select()
                    if index.source_selection_id > 0:
                        index.source_selection.deselect()
                index.source_selection = mouse.collider
                index.source_selection_id = index.source_selection.id
            else:
                if index.source_selection_id > 0:
                    index.source_selection.deselect()
                    index.source_selection_id = -1


    if event is InputEventMouseButton and event.is_pressed():
        var mouse = mouse_collision(event)
        if mouse and mouse.collider.has_method('select'):
            global.emit_signal("region_clicked", mouse.collider, mouse.position)

