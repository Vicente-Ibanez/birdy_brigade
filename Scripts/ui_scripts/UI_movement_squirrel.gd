extends Node3D

# For checking groups 
var type = GameManager.entity_types["squirrel"]

var creature_main_type = "creatures"
var building_type = "buildings"
var other_structures_type = "other_structures"
var resource_main_type = "resources"

# Sidebar variables
@onready var sidebar_scene = "res://Full_Assets/sidebar.tscn"
@onready var sidebar = $Sidebar

@export var creature_positions = []
var left_limit = -500
var right_limit = 1500
var upper_limit = -1350
var lower_limit = 1000
var scroll_upper_limit = 32
var scroll_lower_limit = 12

var speed = 9.0
var speed_normal = 9.0
var sprint = 19
var mouse_sensativity = .7

# For selecting the objects
@onready var camera := $Camera3D
var syncPos = Vector3(0,0,0)
@onready var select := $select

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	## Assign the player to a side depending if a side is already taken
	position = Vector3(position.x, position.y+5, position.z-150)
	rotation.y += 180
	add_to_group(type["side"] + "camera")
	
func _input(event):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		if Input.is_action_just_pressed("camera_zoom_up") and camera.size <= scroll_upper_limit:
			camera.size += 5 
		elif Input.is_action_just_pressed("camera_zoom_down") and camera.size >= scroll_lower_limit:
			camera.size -= 5 
		if Input.is_action_pressed("sprint"):
			speed=sprint
		else:
			speed = speed_normal


func _process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		var input_dir := Input.get_vector(
			"camera_left",
			"camera_right",
			"camera_forward",
			"camera_back"
		)

		# Camera-relative movement, flattened to ground
		var forward := -transform.basis.z
		forward.y = 0
		forward = forward.normalized()

		var right := transform.basis.x
		right.y = 0
		right = right.normalized()

		var direction := (right * input_dir.x + forward * input_dir.y)

		if direction != Vector3.ZERO:
			direction = direction.normalized()

		# Move
		global_position += direction * speed * delta

		# Clamp player position
		global_position.x = clamp(global_position.x, left_limit, right_limit)
		global_position.z = clamp(global_position.z, upper_limit, lower_limit)

		# Sync position
		syncPos = global_position
	else:
		# Smoothly follow networked position
		global_position = global_position.lerp(syncPos, 0.5)
