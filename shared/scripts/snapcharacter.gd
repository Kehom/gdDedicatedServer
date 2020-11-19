# This script is reference material to a written tutorial found on my web page (http://kehomsforge.com)

extends SnapEntityBase
class_name SnapCharacter

var position: Vector3
var orientation: Quat
var vert_velocity: float

func _init(id: int, chash: int = 0).(id, chash) -> void:
	position = Vector3()
	orientation = Quat()
	vert_velocity = 0

func apply_state(n: Node) -> void:
	if (n is KinematicBody && n.has_method("apply_state")):
		n.apply_state({
			"position": position,
			"orientation": orientation,
			"vert_velocity": vert_velocity,
		})
