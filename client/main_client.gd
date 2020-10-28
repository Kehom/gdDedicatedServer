# This script is reference material to a written tutorial found on my web page (http://kehomsforge.com)

extends Node2D

func _ready() -> void:
	# warning-ignore:return_value_discarded
	loader.network.connect("join_fail", self, "_on_join_failed")
	# warning-ignore:return_value_discarded
	loader.network.connect("join_accepted", self, "_on_join_accepted")


func _on_join_failed() -> void:
	$ui/err_dialog.popup_centered()


func _on_join_accepted() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://client/game_client.tscn")


func _on_bt_join_pressed() -> void:
	var port: int = 1234
	if (!$ui/panel/txt_port.text.empty() && $ui/panel/txt_port.text.is_valid_integer()):
		port = $ui/panel/txt_port.text.to_int()
	
	var ip: String = $ui/panel/txt_ip.text
	if (ip.empty()):
		return
	
	loader.network.join_server(ip, port)
