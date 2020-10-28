# This script is reference material to a written tutorial found on my web page (http://kehomsforge.com)

extends Node

# This is the network addon.
var network: Node = null

# The gamestate autoload.
var gamestate: Node = null

# Chache if we are in server or client mode, assuming client
var is_dedicated_server: bool = false

func _ready() -> void:
	# If in standalone mode (that is, exported binary), load the actual resource data pack
	if (OS.has_feature("standalone")):
		# Load the resource pack file named data.pck. The second argument is set to false in order to avoid
		# any existing resource to be overwritten by the contents of this pack.
		# NOTE: ideally this should check the return value and because this basically contains the core of the
		# game logic, if failed then a message box should be displayed and then quit the app/game
		# warning-ignore:return_value_discarded
		ProjectSettings.load_resource_pack("data.pck", false)
	
	var root: Node = get_tree().get_root()
	
	var netclass: Script = load("res://addons/keh_network/network.gd")
	network = netclass.new()
	
	var gstateclass: Script = load("res://shared/scripts/gamestate.gd")
	gamestate = gstateclass.new()
	
	# At this point the tree is still being built, so defer the calls to add children to the root.
	root.call_deferred("add_child", network)
	root.call_deferred("add_child", gamestate)


