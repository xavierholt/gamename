extends Node2D

const WIDTH  = 32
const HEIGHT = 32

const NORTH = 0
const EAST  = 1
const SOUTH = 2
const WEST  = 3

var node
var tiles
var trees

var anytree = load("res://Trees/Scenes/AnyTree.tscn")

func pave(direction):
	var wrange
	var hrange
	if direction == NORTH:
		wrange = range(14, 18)
		hrange = range( 0, 18)
	elif direction == SOUTH:
		wrange = range(14, 18)
		hrange = range(14, 32)
	elif direction == EAST:
		wrange = range(14, 32)
		hrange = range(14, 18)
	elif direction == WEST:
		wrange = range( 0, 18)
		hrange = range(14, 18)
	else:
		print("Unknown direction!")
		return
	for x in wrange:
		for y in hrange:
			if randf() > 0.2:
				tiles.set_cell(x, y, 2)

func wall(direction):
	var rng = range(224, 320, 32)
	if direction == NORTH:
		for x in rng:
			plant(x, 16)
	elif direction == SOUTH:
		for x in rng:
			plant(x, 496)
	elif direction == EAST:
		for y in rng:
			plant(496, y)
	elif direction == WEST:
		for y in rng:
			plant(16, y)
	else:
		print("Unknown direction!")
		return

func offset(direction):
	if direction == NORTH:
		return Vector2(+0, -1)
	elif direction == SOUTH:
		return Vector2(+0, +1)
	elif direction == EAST:
		return Vector2(+1, +0)
	elif direction == WEST:
		return Vector2(-1, +0)
	else:
		print("Unknown direction!")
		return Vector2(0, 0)

func _ready():
	tiles = get_node('Tiles')
	trees = get_parent().get_node('YSort')
	get_node('Area').connect('body_entered', self, 'ensure_next')

func setup(node):
	self.node = node
	node.tile = self
	self.position = Vector2(node.x, node.y) * 512
	for i in range(4):
		if node.neighbors[i]:
			pave(i)
		else:
			wall(i)
	foliate()

func plant(x, y):
	var tree = anytree.instance()
	trees.add_child(tree)
	tree.position = position + Vector2(x, y)

func foliate():
	for i in range(16, 193, 32):
		plant(i, 192 - i)
		plant(288 + i, i)
		plant(i, 288 + i)
		plant(288 + i, 480 - i)

func ensure_next(body):
	# TODO: Be smarter about detecting the player character!
	if not body.get_script(): return
	if not node: return

	var scene = load("res://Mapping/PathTile.tscn")
	for n in node.neighbors:
		if n and n.tile == null:
			var t = scene.instance()
			get_parent().add_child_below_node(self, t)
			t.setup(n)
