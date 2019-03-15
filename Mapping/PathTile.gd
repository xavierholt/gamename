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
var anysign = load("res://SmallObjects/Scenes/AnySign.tscn")

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
		for x in rng: add_tree(x, 50)
	elif direction == SOUTH:
		for x in rng: add_tree(x, 3150)
	elif direction == EAST:
		for y in rng: add_tree(3150, y)
	elif direction == WEST:
		for y in rng: add_tree(50, y)
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
	get_node('Center').connect('body_entered', self, 'centered')
	get_node('Totality').connect('body_entered', self, 'entered')

func setup(node):
	self.node = node
	node.tile = self
	self.position = Vector2(node.x, node.y) * 3200
	for i in range(4):
		if node.neighbors[i]:
			pave(i)
		else:
			wall(i)
	setup_signs()
	setup_trees()

func add_tree(x, y):
	var tree = anytree.instance()
	trees.add_child(tree)
	tree.position = position + Vector2(x, y)

func setup_trees():
	for i in range(22):
		var a = float(i) * PI / 42;
		var x = 1300 * cos(a)
		var y = 1300 * sin(a)
		add_tree(1350 - x, 1350 - y)
		add_tree(1850 + x, 1350 - y)
		add_tree(1850 + x, 1850 + y)
		add_tree(1350 - x, 1850 + y)
	for i in range(50):
		var x = randi() % 3200
		var y = randi() % 3200
		var c = tiles.get_cell(x/100, y/100)
		if c == 0: add_tree(x, y)

func add_sign(x, y):
	var s = anysign.instance()
	trees.add_child(s)
	s.position = position + Vector2(x, y)

func setup_signs():
	if node.arity() < 3:
		return
	if node.neighbors[0]:
		add_sign(1350, 1200)
	if node.neighbors[1]:
		add_sign(2000, 1350)
	if node.neighbors[2]:
		add_sign(1850, 2000)
	if node.neighbors[3]:
		add_sign(1200, 1850)

func entered(body):
	if not "character" in body: return
	var minimap = get_node("/root/Game/Minimap/Map")
	var scene   = load("res://Mapping/PathTile.tscn")
	for n in node.neighbors:
		if not n: continue
		if not n.tile:
			var t = scene.instance()
			get_parent().add_child_below_node(self, t)
			t.setup(n)
		minimap.visit(n, 1)
	minimap.visit(node, 2)

func centered(body):
	if not "character" in body: return
	if node.arity() < 3: return
	get_node("/root/Game").auto_conversation("walk")
