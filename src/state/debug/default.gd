extends "base.gd"

var free_look = false
var prev_mouse_position = Vector3(0,0,0)

func _init():
    name = 'DEFAULT'

func on_enter():
    .on_enter()

func process_input(event):

    if event is InputEventKey:
        if Input.is_key_pressed(KEY_H):
            for region in scene.Grid.get_node('Regions').get_children():
                if region.id == -1:
                    if region.is_visible_in_tree():
                        region.hide()
                    else:
                        region.show()

        if Input.is_key_pressed(KEY_R):
            scene.remove_child(scene.Grid)
            scene.Grid = scene.HexGrid_class.instance()
            scene.Grid.build_all()
            scene.add_child(scene.Grid)

        if Input.is_key_pressed(KEY_W):
            scene.tween.interpolate_property(Camera, 'transform', Camera.transform, Camera.transform.translated(Vector3(0,0,-0.3)), 0.2, Tween.TRANS_SINE, Tween.EASE_IN)
            scene.tween.start()

        if Input.is_key_pressed(KEY_S):
            scene.tween.interpolate_property(Camera, 'transform', Camera.transform, Camera.transform.translated(Vector3(0,0,0.3)), 0.2, Tween.TRANS_SINE, Tween.EASE_IN)
            scene.tween.start()


        if Input.is_key_pressed(KEY_SPACE):
            if !free_look:
                prev_mouse_position.x = 0
            free_look = true
        else:
            if free_look:
                scene.tween.interpolate_property(Camera, 'transform', Camera.transform, scene.original_transform, 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
                scene.tween.start()
            free_look = false

    if free_look and event is InputEventMouseMotion:
        if prev_mouse_position.x == 0:
            prev_mouse_position = event.position
        var diff = event.position - prev_mouse_position
        Camera.transform = scene.original_transform.rotated(Vector3(0,1,0), PI / 2 * diff.x / 300).rotated(Vector3(1,0,0), PI / 2 * diff.y / 300)




