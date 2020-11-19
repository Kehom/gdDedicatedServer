tool
extends Spatial
class_name NetMeshInstance

# Expose the mesh property - this will be applied to the MeshInstance node if it's created. Any other property of the
# MeshInstance can be exposed like this
export var mesh: Mesh = null setget set_mesh

# Store the InstanceMesh node here
var _mesh_node: MeshInstance = null


func _ready() -> void:
	if (Engine.is_editor_hint() || !loader.is_dedicated_server):
		_mesh_node = MeshInstance.new()
		_mesh_node.set_name("mesh")
		add_child(_mesh_node)
		# This is necessary for pre-created nodes (level design for example)
		_mesh_node.mesh = mesh


func set_mesh(m: Mesh) -> void:
	mesh = m
	call_deferred("_check_mesh")


func _check_mesh() -> void:
	if (_mesh_node):
		_mesh_node.mesh = mesh
