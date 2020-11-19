# This script is reference material to a written tutorial found on my web page (http://kehomsforge.com)

tool
extends StaticBody
class_name StaticBase

export var mesh: Mesh = null setget set_mesh

var _mesh_node: MeshInstance = null

func _ready() -> void:
	if (Engine.is_editor_hint() || !loader.is_dedicated_server):
		_mesh_node = MeshInstance.new()
		_mesh_node.set_name("mesh")
		add_child(_mesh_node)
		_mesh_node.mesh = mesh         # Probably not necessary but it should be no harm in doing so


# It is actually "harmful" to cleanup the mesh node here. What happens is that, in the editor, when the scene tab is
# used to switch back and forth, the mesh node will not be rebuilt.
#func _exit_tree() -> void:
	# This is probably not entirely necessary because _mesh_node is owned by this node and will be deleted
	# But still, this cleanup is harmless
#	if (_mesh_node):
#		_mesh_node.queue_free()
#		_mesh_node = null

func set_mesh(m: Mesh) -> void:
	mesh = m
	call_deferred("_check_mesh")

func _check_mesh() -> void:
	if (_mesh_node):
		_mesh_node.mesh = mesh
