extends Node

var parent
var nav_agent
var multi_sync
var speed = 5
#var syncPos 

func _ready():
	parent = $".."
	nav_agent = $"../NavigationAgent3D"
	multi_sync = $"../MultiplayerSynchronizer"
	#syncPos = parent.syncPos


func _physics_process(delta):
	if multi_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
		parent.syncPos = parent.global_position
		if not nav_agent.is_navigation_finished():
			var current_location = parent.global_transform.origin
			var next_location = nav_agent.get_next_path_position()
			var new_velocity = (next_location - current_location).normalized() * speed

			var collision = parent.move_and_collide(new_velocity * delta)
			#if collision:
				#if collision.get_collider().type["sub_type"]=="river":
					#collision.get_collider().get_parent().float_down_river(self)
	else:
		parent.global_position = parent.global_position.lerp(parent.syncPos, .5)

func set_location(pos):
	if multi_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
		parent.syncPos = parent.global_position
		parent.position = pos
	else:
		parent.global_position = parent.global_position.lerp(pos, .5)

func update_target_location(target_location):
	nav_agent.set_target_position(target_location)
