# This script is reference material to a written tutorial found on my web page (http://kehomsforge.com)

extends Control

var pid: int = 0

func set_data(id: int) -> void:
	pid = id
	$lbl_id.text = str(id)


func _on_bt_kick_pressed() -> void:
	if (pid != 0):
		# Bellow we could retrieve the message from a line edit instead of hard coding it.
		loader.network.kick_player(pid, "You have been kicked")
