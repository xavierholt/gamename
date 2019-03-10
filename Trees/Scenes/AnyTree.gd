extends Node2D

var TREES = [
	load("res://Trees/Scenes/PineTreeS.tscn"),
	load("res://Trees/Scenes/PineTreeM.tscn"),
	load("res://Trees/Scenes/PineTreeL.tscn"),
	load("res://Trees/Scenes/GreenTreeS.tscn"),
	load("res://Trees/Scenes/GreenTreeM.tscn"),
	load("res://Trees/Scenes/GreenTreeL.tscn"),
	load("res://Trees/Scenes/OrangeTreeS.tscn"),
	load("res://Trees/Scenes/OrangeTreeM.tscn"),
	load("res://Trees/Scenes/OrangeTreeL.tscn")
]

func _ready():
	# TODO: Tree type gradients?
	add_child(TREES[randi() % 9].instance())
