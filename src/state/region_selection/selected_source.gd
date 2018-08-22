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
    # scene.tween.interpolate_property(
    #     Camera,
    #     'transform',
    #     Camera.transform,
    #     Camera.transform.rotated(Vector3(0,1,0), PI / 2 * 0 / 300).rotated(Vector3(1,0,0), PI / 2 * 100 / 300).translated(Vector3(0,-0.3,0)),
    #     TILT_SPEED,
    #     Tween.TRANS_SINE,
    #     Tween.EASE_IN
    # )
    # scene.tween.start()

func on_exit():
    # scene.tween.interpolate_property(
    #     Camera,
    #     'transform',
    #     Camera.transform,
    #     camera_transform,
    #     TILT_SPEED,
    #     Tween.TRANS_SINE,
    #     Tween.EASE_IN
    # )
    # scene.tween.start()
    Arrow.hide()
    if index.source_selection_id > 0:
        index.source_selection.deselect()
        index.source_selection_id = -1
    if index.target_selection_id > 0:
        index.target_selection.deselect()
        index.target_selection_id = -1

func process_input(event):
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

