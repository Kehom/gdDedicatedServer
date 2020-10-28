# This script is reference material to a written tutorial found on my web page (http://kehomsforge.com)

extends Node

var dc_message: String = "Disconnected from the server."

func _ready() -> void:
	# warning-ignore:return_value_discarded
	loader.network.connect("kicked", self, "_on_kicked")
	# warning-ignore:return_value_discarded
	loader.network.connect("disconnected", self, "_on_disconnected")
	
	# Notify the server that this client is ready to receive snapshot data
	loader.network.notify_ready()


func _exit_tree() -> void:
	loader.network.reset_system()
	# No harm if already disconnected
	loader.network.disconnect_from_server()


func _physics_process(_dt: float) -> void:
	# Request initialization of the snapshot for this physics frame
	loader.network.init_snapshot()


func _on_kicked(reason: String) -> void:
	dc_message = reason


func _on_disconnected() -> void:
	set_pause_mode(Node.PAUSE_MODE_STOP)
	$ui/dc_dialog.dialog_text = dc_message
	$ui/dc_dialog.popup_centered()



func _on_dc_dialog_confirmed() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://client/main_client.tscn")
