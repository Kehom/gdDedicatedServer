# This script is reference material to a written tutorial found on my web page (http://kehomsforge.com)

extends Node2D

func _ready() -> void:
	# Connect functions to the events given by the networking system
	# warning-ignore:return_value_discarded
	loader.network.connect("server_created", self, "_on_server_created")
	# warning-ignore:return_value_discarded
	loader.network.connect("server_creation_failed", self, "_on_server_creation_failed")


func _on_server_created() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://server/game_server.tscn")


func _on_server_creation_failed() -> void:
	$ui/err_dialog.popup_centered()



func _on_bt_start_pressed() -> void:
	# This is the default value, which will be used in case the specified one in the line edit is invalid
	var port: int = 1234
	if (!$ui/panel/txt_port.text.empty() && $ui/panel/txt_port.text.is_valid_integer()):
		port = $ui/panel/txt_port.text.to_int()
	
	# Same thing for maximum amount of players
	var mplayers: int = 6
	if (!$ui/panel/txt_maxplayers.text.empty() && $ui/panel/txt_maxplayers.text.is_valid_integer()):
		mplayers = $ui/panel/txt_maxplayers.text.to_int()
	
	# Try to create the server
	loader.network.create_server(port, "Awesome Server Name", mplayers)
