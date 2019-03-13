extends Node

var Map = load("res://Mapping/PathMap.gd")
var map

func _ready():
	map = Map.new(10, 10)
	get_node("Map/PathTile").setup(map.node(0, 0))
	var misha  = get_node("Map/YSort/Misha")
	var andrew = get_node("Map/YSort/Andrew")
	andrew.leader = misha
