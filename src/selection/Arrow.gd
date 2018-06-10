extends Spatial

var original_transform
var hex_class = preload('../hex/Cell.tscn')
var hex

func _ready():
	hex = hex_class.instance()
	hex.radius = 0.1
	hex.height = -0.01
	add_child(hex)
	hex.transform = $Area.transform
	original_transform = transform
	global.connect('region_clicked', self, 'region_clicked')
	global.connect('mouse_move', self, 'mouse_move')

func region_clicked(region, click_position):
	if is_visible_in_tree():
		$Tween.interpolate_property(
			self,
			"transform",
			transform,
			original_transform.translated(click_position),
			3,
			Tween.TRANS_EXPO,
			Tween.EASE_OUT
		)
		$Tween.start()
	else:
		transform = original_transform.translated(click_position)
		show()

func mouse_move(position, screen_position):
	if is_visible_in_tree():
		var direction = position - get_translation()
		hex.update_size(direction.length())


func _process(delta):
	look_at_mouse(global.mouse_position, global.mouse_screen_position)


func look_at_mouse(position, screen_position):
	var direction = position - get_translation()
	var angle = Vector3(0, 1, 0).angle_to(direction)

	if direction.x > 0:
		angle = angle * -1

	self.rotation.z = angle
