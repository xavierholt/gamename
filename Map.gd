extends Node

var conversation = null

func _ready():
	randomize()
	get_node('Map/PathSegment').enter(0)
	get_node('Map/PathSegment').foliate()
