extends "../base.gd"

var Camera
var Arrow

func on_enter():
    Camera = scene.get_node('Camera')
    Arrow = scene.get_node('Arrow')


func mouse_collision(event):
    var mouse_pos = event.position
    var space_state = scene.get_world().get_direct_space_state()

    var from = Camera.project_ray_origin(mouse_pos)
    var to = from + Camera.project_ray_normal(mouse_pos) * 10000

    return space_state.intersect_ray( from, to )

func arrow_collision(event):

    var space_state = scene.get_world().get_direct_space_state()

    var tip_pos = Arrow.translation + Arrow.get_tip_pos()
    var tip_2d_pos = Camera.unproject_position(tip_pos)

    var from = Camera.project_ray_origin(tip_2d_pos)
    var to = from + Camera.project_ray_normal(tip_2d_pos) * 10000

    return space_state.intersect_ray( from, to )

func on_region_clicked(region, position):
    pass