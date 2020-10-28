# This script is reference material to a written tutorial found on my web page (http://kehomsforge.com)

extends Node

# Preaload the UI Player scene, which will be instantiated whenever a player joins the game
const uiplayer_scene: PackedScene = preload("res://server/ui/player.tscn")

# Key = player ID
# Value = whatever data we need associated with the player.
var player_data: Dictionary = {}


func _ready() -> void:
	# warning-ignore:return_value_discarded
	loader.network.connect("player_added", self, "_on_player_added")
	# warning-ignore:return_value_discarded
	loader.network.connect("player_removed", self, "_on_player_removed")


func _exit_tree() -> void:
	loader.network.reset_system()


func _physics_process(_dt: float) -> void:
	# Request initialization of the snapshot for this physics frame
	loader.network.init_snapshot()


func _on_bt_quit_pressed() -> void:
	# Close the server
	loader.network.close_server()
	# Then quit the app
	get_tree().quit()


func _on_bt_close_pressed() -> void:
	# Close the server
	loader.network.close_server()
	# Return to the main menu
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://server/main_server.tscn")


func _on_player_added(pid: int) -> void:
	# Create instance of the UI element
	var uielement: Node = uiplayer_scene.instance()
	uielement.set_data(pid)
	
	# Attach it into the vbox
	$ui/panel/scroll/vbox.add_child(uielement)
	
	# Sawpn the character node
	var cnode: KinematicBase = loader.network.snapshot_data.spawn_node(SnapCharacter, pid, 0)
	# Obtain the index of the spawn point
	var index: int = loader.network.player_data.get_player_count() - 1
	# Place the character at the spawn point
	cnode.global_transform.origin = $game.get_spawn_position(index)
	
	# Cache the node
	player_data[pid] = {
		"ui_element": uielement,
	}


func _on_player_removed(pid: int) -> void:
	# Obtain the player data
	var pdata: Dictionary = player_data.get(pid, {})
	
	# Bail if the obtained entry does not exist (IE.: it's empty)
	if (pdata.empty()):
		return
	
	# "ui_element" should point to the node within the vbox container. So, queue free it
	pdata.ui_element.queue_free()
	# Then erase from the cached data
	# warning-ignore:return_value_discarded
	player_data.erase(pid)
	
	# De-spawn the player character
	loader.network.snapshot_data.despawn_node(SnapCharacter, pid)
