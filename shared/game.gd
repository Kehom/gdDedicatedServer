# This script is reference material to a written tutorial found on my web page (http://kehomsforge.com)

extends Spatial


func _ready() -> void:
	# The default spawner require the scene, so load it
	var charscene: PackedScene = load("res://shared/scenes/character.tscn")
	# Register network entity spawner for the characters
	loader.network.snapshot_data.register_spawner(SnapCharacter, 0, NetDefaultSpawner.new(charscene), self)



func get_spawn_position(index: int) -> Vector3:
	# Just some boundary check. If there is any intention to change the number of spawn points during development,
	# perhaps it would be a better idea to put those nodes into a group and use the size within this check
	if (index < 0 || index > 7):
		return Vector3()
	
	# Locate the spawn point node given its index
	var p: Position3D = get_node("spawn_points/" + str(index))
	# Provide this node's global position
	return p.global_transform.origin
