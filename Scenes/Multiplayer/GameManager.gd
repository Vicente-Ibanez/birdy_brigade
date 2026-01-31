extends Node
# This script was added to autoload 
# So we can access players at any time

var  Players = {}


var entity_types = {
	"squirrel":{
		"main_type": "creatures",
		"sub_type": "squirrel",
		"side": "squirrel",
		"enemy": "bird",
		"has_inventory": "true",
		"can_pickup":"false"
	},
	"bird":{
		"main_type": "creatures",
		"sub_type": "bird",
		"side": "bird",
		"enemy": "squirrel",
		"has_inventory": "true",
		"can_pickup":"false"
	},
	"main_base":{
		"main_type": "buildings",
		"sub_type": "main_building",
		"side": "", #"squirrel/bird",
		"enemy": "", #"squirrel/bird",
		"has_inventory": "true",
		"can_pickup":"false"
	},
	"pebbles":{
		"main_type": "resources",
		"sub_type": "pebble",
		"side": "neutral",
		"enemy": "neutral",
		"has_inventory": "false",
		"can_pickup":"true"
	},
	"mushrooms": {
		"main_type": "structures",
		"sub_type": "mushroom",
		"side": "neutral",
		"enemy": "neutral",
		"has_inventory": "false",
		"can_pickup":"ture"
	},
	"tree": {
		"main_type": "other_structures",
		"sub_type": "tree",
		"side": "neutral",
		"enemy": "neutral",
		"has_inventory": "false",
		"can_pickup":"false"
	}
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
