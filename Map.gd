extends Node

func _ready():
	randomize()
	get_node('Map/PathSegment').enter(0)
	get_node('Map/PathSegment').foliate()
