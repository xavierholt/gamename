tool extends Node2D

var TREES = [
	load("res://Trees/Scenes/PineTreeXL.tscn"),
	load("res://Trees/Scenes/GreenTreeXL.tscn"),
	load("res://Trees/Scenes/GreenTreeXXL.tscn"),
	load("res://Trees/Scenes/OrangeTreeXL.tscn"),
	load("res://Trees/Scenes/OrangeTreeXXL.tscn")
]

func _ready():
	for child in get_children():
		child.queue_free()
	var tree = TREES[randi() % 5].instance()
	if randi() % 2: tree.scale = Vector2(-1, 1)
	add_child(tree)
