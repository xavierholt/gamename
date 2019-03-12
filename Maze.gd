extends Node

var Map = load("res://PathMap.gd")
var map

func _ready():
	map = Map.new(10, 10)
	get_node("Map/PathTile").setup(map.node(0, 0))
