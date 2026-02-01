extends Node3D

@onready var camera := $"../Camera3D"
@onready var multi_sync := $"../MultiplayerSynchronizer"
var select_box_parents = []
@onready var select_box := preload("res://Full_Assets/select_box_full.tscn")
@onready var parent := $".."

func _input(event):
	if multi_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
		# Click on Objects in Scene
		if Input.is_action_just_pressed("left_mouse"):
			var result = cast_ray_to_select()
			if result:
				try_to_select(result)
		if Input.is_action_just_pressed("clear_selection"):
			clear_selection()

func cast_ray_to_select():
	"""" 
	This function casts a ray from the camera that returns the 
	first thing the ray hits, can be null.
	"""
	if multi_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
		var mouse_pos = get_viewport().get_mouse_position()
		var ray_length = 100
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * ray_length
		var space = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.new()
		ray_query.from = from
		ray_query.to = to
		ray_query.collide_with_areas = true
		var result = space.intersect_ray(ray_query)
		return result

func try_to_select(result):
	""" 
		Function determines the object's type and
		then dispatches the troops to do the proper 
		action.
	"""
	
	if multi_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
		var object = result["collider"]
		
		# Player clicked the ground, move troops there
		if object.is_in_group("terrain"):
			assign_creature_target(object)
			return

		# If object doesn't have type, try to get type or ignore click
		if (not "type" in object):
			object = object.get_parent()
			if (not "type" in object):
				return

		# Selecting an ally soldier, select it
		if object.type["side"]==parent.type["side"] and object.type["main_type"]==parent.creature_main_type:
			multiple_select(object)
		# Selecting an enemy, attack it
		elif object.type["side"]==parent.type["enemy"]:
			assign_creature_target(object)
		# Selecting a tree
		elif object.type["sub_type"] == "tree": #or collider.is_in_group(parent.resource_main_type):
			assign_creature_target(object)
		
		## Depositing resources in base on player's side
		#elif object.is_in_group(building_type) and object.is_in_group(side):
			#attack_enemy_object(object)
			#if object.is_in_group("has_inventory_true") and object.is_in_group("sub_type_base_main_base"):
				#print_debug("TESTING OPEN INVENTORY OF Squirrel", object)
				#object.open_inventory()

func assign_creature_target(enemy_object):
	if multi_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
		# Command each selected soldier to target the enemy soldier
		for select_box_parent in select_box_parents:
			# If the soldier and enemy_soldier still exist
			if select_box_parent[0] and enemy_object:
				select_box_parent[0].assign_target(enemy_object)


# Selecting ally troops
func clear_selection():
	""" This function clears all selected soldiers """
	if multi_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
		# Deselect all current select boxs
		for select_box_parent in select_box_parents:
			# If the parent still exists
			if select_box_parent[0]:
				# Remove the selection 
				select_box_parent[0].remove_child(select_box_parent[1])
		# Then clear the list
		select_box_parents = []

func multiple_select(object):
	""" This function controls selecting multiple soldiers on your team """
	if multi_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
		# If selecting multiple objects
		var reselected_index = -1
		var index = -1
		for select_box_parent in select_box_parents:
			index += 1
			# If the object is on the list, mark it
			if object == select_box_parent[0]:
				reselected_index = index
	
		# If the object is not reselected, select it and add it to selected objects
		if reselected_index == -1:
			var new_select_box = select_box.instantiate()
			object.add_child(new_select_box)
			select_box_parents.append([object, new_select_box])
		# Otherwise, the object is reselect and needs to be deselected
		else:
			# Check if object still exists
			select_box_parents[reselected_index][0].remove_child(select_box_parents[reselected_index][1])
			# Regardless of if it exists, remove it from the list
			select_box_parents.remove_at(reselected_index)
