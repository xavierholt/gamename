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
				tiles.set_cell(x, y, 1)

func wall(direction):
	var rng = range(1450, 1751, 100)
	if direction == NORTH:
		for x in rng: plant(x, 50)
	elif direction == SOUTH:
		for x in rng: plant(x, 3150)
	elif direction == EAST:
		for y in rng: plant(3150, y)
	elif direction == WEST:
		for y in rng: plant(50, y)
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
	self.position = Vector2(node.x, node.y) * 3200
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
	for a in range(0, 91, 4.5):
		var x = 1300 * cos(deg2rad(a))
		var y = 1300 * sin(deg2rad(a))
		plant(1350 - x, 1350 - y)
		plant(1850 + x, 1350 - y)
		plant(1850 + x, 1850 + y)
		plant(1350 - x, 1850 + y)
	for i in range(50):
		var x = randi() % 3200
		var y = randi() % 3200
		var c = tiles.get_cell(x/100, y/100)
		if c == 0: plant(x, y)

func ensure_next(body):
	# TODO: Be smarter about detecting the player character!
	if not body.get_script(): return
#	if not node: return

	var scene = load("res://Mapping/PathTile.tscn")
	for n in node.neighbors:
		if n and n.tile == null:
			var t = scene.instance()
			get_parent().add_child_below_node(self, t)
			t.setup(n)
