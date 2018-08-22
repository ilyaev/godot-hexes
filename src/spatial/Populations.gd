extends Spatial

var population = 0
var shift_z = 0.055
var scene_cube = preload('PopulationCube.tscn')

func _ready():
	pass

func update(new_population):
	for cube in $Cubes.get_children():
		cube.queue_free()

	population = new_population
	for i in range(population):
		var cube = scene_cube.instance()
		var osign = 0
		var cube_transform = cube.transform.translated(Vector3(-0.03, 0, 0))

		var ii = i
		if i > 3:
			cube_transform = cube.transform.translated(Vector3(0.03, 0, 0))
			ii = i - 4

		cube.transform = cube_transform.translated(Vector3(0,ii * 0.02 * osign, ii * shift_z))
		$Cubes.add_child(cube)
