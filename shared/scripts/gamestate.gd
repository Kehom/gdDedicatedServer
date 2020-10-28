# This script is reference material to a written tutorial found on my web page (http://kehomsforge.com)

extends Node

func _ready() -> void:
	# Register input within the network system
	loader.network.register_action("move_forward", false)
	loader.network.register_action("move_backward", false)
	loader.network.register_action("move_left", false)
	loader.network.register_action("move_right", false)
	loader.network.register_action("jump", false)
