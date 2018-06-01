extends Spatial

var segments = []
var surface # = SurfaceTool.new()
var mat = SpatialMaterial.new()
var mesh = Mesh.new()

func _ready():
    build_mesh()
    pass

func add_segment(plane):
    segments.append(plane)

func build_mesh():
    surface = global.Surface
    if mesh.get_surface_count() > 0:
        mesh.surface_remove(0)
    surface.clear()
    surface.begin(Mesh.PRIMITIVE_TRIANGLES)

    for segment in segments:
        surface.add_vertex(segment[0])
        surface.add_vertex(segment[1])
        surface.add_vertex(segment[2])

        surface.add_vertex(segment[0])
        surface.add_vertex(segment[2])
        surface.add_vertex(segment[3])

    surface.generate_normals()
    surface.index()

    surface.commit(mesh)

    mat.set_albedo(Color(0,0,0))

    $Mesh.set_mesh(mesh)
    $Mesh.set_material_override(mat)


