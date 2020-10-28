# This script is reference material to a written tutorial found on my web page (http://kehomsforge.com)

extends Node

func _ready() -> void:
	# By default open the client main menu
	var spath: String = "res://client/main_client.tscn"
	if ("--server" in OS.get_cmdline_args() || OS.has_feature("dedicated_server")):
		# Requesting to open in server mode, so change the string to it
		spath = "res://server/main_server.tscn"
		# Cache that we are indeed in server mode
		loader.is_dedicated_server = true
		#loader.network.set_dedicated_server_mode(true)
		loader.network.call_deferred("set_dedicated_server_mode", true)
	
	# And transition into the appropriate scene
	# warning-ignore:return_value_discarded
	get_tree().change_scene(spath)
