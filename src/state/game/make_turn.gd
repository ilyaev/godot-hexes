extends 'base.gd'

var Hud

func _init():
    name = 'MAKE_TURN'

func on_enter():
    # if index.active_player > 0:
    set_state(index.STATE_MAKE_TURN_AI)
    pass

func process_input(event):
    var result = []

    if event is InputEventKey:
        if Input.is_key_pressed(KEY_ENTER):
            result.append({
                "id": commands.CMD_END_TURN
            })

    return result