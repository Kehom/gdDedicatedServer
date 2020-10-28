# This script is reference material to a written tutorial found on my web page (http://kehomsforge.com)

tool
extends KinematicBase

# Gravity constant
const GRAVITY: float = 9.81

# Determines the speed in which the character will move
export var movement_speed: float = 9.0

# Initial vertical velocity when jumping
export var vert_v0: float = 5.4

# If true, character can jump
var _can_jump: bool = false

# Accumulate vertical acceleration
var _vert_vel: float = 0.0

# Cache incoming server state. It includes a flag telling if the data is actually a correction or not
var _correction: Dictionary = { "has_correction": false }

# Cache the entity unique ID in here
var _uid: int = 0


func _ready() -> void:
	# If in editor simply disable processing as it's not needed here
	if (Engine.is_editor_hint()):
		set_physics_process(false)
	
	if (has_meta("uid")):
		_uid = get_meta("uid")
	
	if (loader.network.is_id_local(_uid)):
		# Create the camera
		var cam: Camera = Camera.new()
		# Attach to the node hierarchy
		$camera_pos.add_child(cam)
		# Ensure it is the active one
		cam.current = true

func _physics_process(dt: float) -> void:
	# Check if there is any correction to be done
	if (_correction.has_correction):
		# Yes, there is. Apply it
		global_transform.origin = _correction.position
		global_transform.basis = Basis(_correction.orientation)
		_vert_vel = _correction.vert_velocity
		# Reset the flag so correction doesn't occur when not needed
		_correction.has_correction = false
		
		# Replay input objects within internal history if this character belongs to local player
		if (loader.network.is_id_local(_uid)):
			var input_list: Array = loader.network.player_data.local_player.get_cached_input_list()
			for i in input_list:
				_handle_input(dt, i)
				loader.network.correct_in_snapshot(generate_snap_object(), i)
	
	# Handle input
	_handle_input(dt, loader.network.get_input(_uid))
	
	# Snapshot current state
	loader.network.snapshot_entity(generate_snap_object())

# InputData is a class type defined within the Network addon.
func _handle_input(dt: float, input: InputData) -> void:
	if (!input):
		return
	
	var jump_pressed: bool = input.is_pressed("jump")
	var vel: Vector3 = Vector3()
	var aim: Basis = global_transform.basis
	
	if (input.is_pressed("move_forward")):
		vel -= aim.z
	if (input.is_pressed("move_backward")):
		vel += aim.z
	if (input.is_pressed("move_left")):
		vel -= aim.x
	if (input.is_pressed("move_right")):
		vel += aim.x
	
	# Normalize the horizontal movement and apply movement speed
	vel = vel.normalized() * movement_speed
	
	# Check jump
	vel.y = _vert_vel
	if (_can_jump && jump_pressed):
		vel.y = vert_v0
		_can_jump = false
	
	# Integrate gravity. Yes, this is not a good integrator but it should be OK for this demo
	vel.y -= (GRAVITY * dt)
	
	# Move. Giving a bunch of arguments with their default values in order to reach the last argument, which
	# must be false in order for collisions to properly work with rigid bodies.
	vel = move_and_slide(vel, Vector3.UP, false, 4, 0.785398, false)
	_vert_vel = vel.y
	
	# Cache the "can jump" situation so it can be used at a more intuitive location within this code.
	_can_jump = is_on_floor() && !jump_pressed


func apply_state(state: Dictionary) -> void:
	# Take the server state and cache it
	_correction["position"] = state.position
	_correction["orientation"] = state.orientation
	_correction["vert_velocity"] = state.vert_velocity
	# And set the flag indicating that a correction is necessary
	_correction["has_correction"] = true


func generate_snap_object() -> SnapCharacter:
	# Second argument, class hash, is required but we don't use it, so setting to 0
	var snap: SnapCharacter = SnapCharacter.new(_uid, 0)
	
	# Transfer the character state into the object
	snap.position = global_transform.origin
	snap.orientation = global_transform.basis.get_rotation_quat()
	snap.vert_velocity = _vert_vel
	
	return snap
