extends Spatial

var population = 0
var shift_z = 0.055
var scene_cube = preload('PopulationCube.tscn')

func _ready():
	pass

func get_cube_position(i):
	var osign = 0
	var cube_transform = Transform(Basis(Vector3(0,0,0))).translated(Vector3(-0.03, 0, 0))

	var ii = i
	if i > 3:
		cube_transform = Transform(Basis(Vector3(0,0,0))).translated(Vector3(0.03, 0, 0))
		ii = i - 4

	return cube_transform.translated(Vector3(0,ii * 0.02 * osign, ii * shift_z))

func add_cube():
	var cube_transform = get_cube_position(population)
	population = population + 1
	var cube = scene_cube.instance()
	var from_transform = cube_transform.translated(Vector3(0,0, 0.5))
	var tween = Tween.new()
	tween.interpolate_property(
		cube,
		'transform',
		from_transform,
		cube_transform,
		randf() * 0.5 + 0.4,
		Tween.TRANS_BOUNCE,
		Tween.EASE_OUT
	)
	tween.connect("tween_completed", self, "on_new_cube_added", [tween])
	add_child(cube)
	add_child(tween)
	tween.start()
	return tween
	pass

func on_new_cube_added(obj, path, tween):
	tween.queue_free()

func update(new_population):
	for cube in $Cubes.get_children():
		cube.queue_free()

	population = new_population
	for i in range(population):
		var cube = scene_cube.instance()
		cube.transform = get_cube_position(i) # cube_transform.translated(Vector3(0,ii * 0.02 * osign, ii * shift_z))
		$Cubes.add_child(cube)
