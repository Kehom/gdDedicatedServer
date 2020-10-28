# This script is reference material to a written tutorial found on my web page (http://kehomsforge.com)

tool
extends KinematicBody
class_name KinematicBase

export var mesh: Mesh = null setget set_mesh

var _mesh_node: MeshInstance = null


func _ready() -> void:
	if (Engine.is_editor_hint() || !loader.is_dedicated_server):
		_mesh_node = MeshInstance.new()
		_mesh_node.set_name("mesh")
		$visual.add_child(_mesh_node)


func _exit_tree() -> void:
	if (_mesh_node):
		_mesh_node.queue_free()
		_mesh_node = null


func set_mesh(m: Mesh) -> void:
	mesh = m
	call_deferred("_check_mesh")

func _check_mesh() -> void:
	if (_mesh_node):
		_mesh_node.mesh = mesh
