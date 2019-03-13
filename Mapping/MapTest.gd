extends Node2D

var Map = load("res://Mapping/PathMap.gd")
var map

func _ready():
	randomize()
	map = Map.new(64, 37)
	var arities = [0, 0, 0, 0, 0]
	var mini = get_node("TileMap")
	for x in range(map.width):
		for y in range(map.height):
			var node = map.nodes[x][y]
			mini.set_cell(x, y, node.bits())
			arities[node.arity()] += 1
	var n = float(map.width * map.height)
	for i in range(5):
		arities[i] /= n / 100
	print(arities)
