tool extends Node2D

var TREES = [
	load("res://Trees/Scenes/Cluster01.tscn"),
	load("res://Trees/Scenes/Cluster02.tscn"),
	load("res://Trees/Scenes/Cluster03.tscn"),
	load("res://Trees/Scenes/Cluster04.tscn"),
	load("res://Trees/Scenes/Cluster05.tscn"),
	load("res://Trees/Scenes/Cluster06.tscn"),
	load("res://Trees/Scenes/Cluster07.tscn"),
	load("res://Trees/Scenes/Cluster08.tscn"),
	load("res://Trees/Scenes/Cluster09.tscn"),
	load("res://Trees/Scenes/Cluster10.tscn")
]

func _ready():
	# TODO: Tree type gradients?
	for child in get_children():
		child.queue_free()
	var tree = TREES[randi() % 10].instance()
	if randi() % 2: tree.scale = Vector2(-1, 1)
	add_child(tree)
