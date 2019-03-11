extends Node2D

const WIDTH  = 32
const HEIGHT = 32

const WEST  = 0
const SOUTH = 1
const EAST  = 2
const NORTH = 3

var tiles
var trees

var enter_direction = null
var leave_direction = null
var next            = null

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
	for x in range(WIDTH):
		for y in range(HEIGHT):
			tiles.set_cell(x, y, randi() % 101 / 100)

func enter(direction):
	enter_direction = direction
	while true:
		leave_direction = randi() % 3 + 1
		if leave_direction != direction:
			pave(leave_direction)
			break
	pave(enter_direction)

func foliate():
	var scene = load("res://Trees/Scenes/AnyTree.tscn")
	for i in range(12):
		var tree = scene.instance()
		trees.add_child(tree)
		tree.position = position + Vector2(randf(), randf()) * 512

func ensure_next(body):
	if next == null and body.get_script():
		var scene = load("res://PathSegment.tscn")
		next = scene.instance()
		get_parent().add_child_below_node(self, next)
		next.position = position + offset(leave_direction) * 512
		next.enter((leave_direction + 2) % 4)
		next.foliate()
