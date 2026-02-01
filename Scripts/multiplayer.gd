extends Node3D

@export var PlayerScene: PackedScene

@rpc("any_peer")
func _ready():
	var PlayerOrder = 0
	
	var gamePlayers = []
	for gamePlayer in GameManager.Players:
		gamePlayers.append(GameManager.Players[gamePlayer].id)
	
	gamePlayers.sort()
	if str(gamePlayers[0]).to_int() == multiplayer.get_unique_id():
		PlayerOrder = 1
	else:
		PlayerOrder = 0
	
	var spawnPoss = get_tree().get_nodes_in_group("PlayerSpawnPoint")
	
	var player_type = ["bird", "squirrel"]
	var i = 0
	for player in gamePlayers:
		var p = PlayerScene.instantiate()
		p.name = str(gamePlayers[i])
		p.type = GameManager.entity_types[player_type[i]]
		add_child(p)
		
		p.global_position = spawnPoss[i].global_position
		i+= 1
		print_debug("Making Camera", multiplayer.is_server())
		
	
