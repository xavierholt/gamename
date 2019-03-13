var Node = load("res://Mapping/PathNode.gd")
var Edge = load("res://Mapping/PathEdge.gd")

const DX = [ 0, +1,  0, -1]
const DY = [-1,  0, +1,  0]

var width
var height
var nodes = []

func _init(w, h):
	width  = w
	height = h
	# Create path nodes:
	nodes.resize(width)
	for x in range(width):
		var column = []
		column.resize(height)
		for y in range(height):
			column[y] = Node.new(self, x, y)
		nodes[x] = column
	crawler()
	lillian()
	# TODO: Add points of interest

func kruskal():
	# Find all possible edges:
	var edges = []
	for x in range(width):
		for y in range(height):
			if x > 0: edges.push_back(Edge.new(node(x-1, y), node(x, y)))
			if y > 0: edges.push_back(Edge.new(node(x, y-1), node(x, y)))
	# Shuffle the edges:
	for i in range(len(edges)):
		var j = randi() % (len(edges) - i)
		var t = edges[i]
		edges[i] = edges[i+j]
		edges[i+j] = t
	# Add edges until everything is connected:
	for e in edges:
		if e.src.union(e.dst):# or distance(e.src, e.dst) > 8:
			self.join(e.src, e.dst)

func crawler_helper(n):
	var r  = randi()
	for i in range(4):
		var d = (r + i) % 4
		var m = node(n.x + DX[d], n.y + DY[d])
		if m and m.parent == m:
			return m
	return null

func crawler():
	var c = width * height - 1
	var n = node(width/2, height/2)
	n.parent = null
	while c > 0:
		var m = crawler_helper(n)
		if m:
			self.join(n, m)
			m.parent = n
			n  = m
			c -= 1
		else:
			n = n.parent

func distance(src, dst, limit = -1):
	var seen = {src: true}
	var curr = []
	var step = 2
	if src == dst:
		return 0
	for node in src.neighbors:
		if node == dst:
			return 1
		if node:
			curr.push_back(node)
			seen[node] = true
	while curr:
		var next = []
		for s in curr:
			for d in s.neighbors:
				if d == dst:
					return step
				if d and not d in seen:
					next.push_back(d)
					seen[d] = true
		if step == limit:
			return limit
		curr = next
		step += 1
	print("Nodes not connected!")
	return -1

func lillian():
	for x in range(width):
		for y in range(height):
			var n = nodes[x][y]
			if n.arity() != 1: continue
			if x == 0 or x == width  - 1: continue
			if y == 0 or y == height - 1: continue
			if randf() < 0.3: continue
			var m = null
			var d = -1
			for i in range(4):
				var o = node(x + DX[i], y + DY[i])
				if not o: continue
				var e = distance(n, o)
				if e > d:
					m = o
					d = e
			join(n, m)

func join(src, dst):
	if src.x == dst.x:
		var d = 0 if(src.y < dst.y) else 2
		src.neighbors[(2 + d) % 4] = dst
		dst.neighbors[(0 + d) % 4] = src
	else:
		var d = 0 if(src.x < dst.x) else 2
		src.neighbors[(1 + d) % 4] = dst
		dst.neighbors[(3 + d) % 4] = src

func node(x, y):
	if x < 0 or x >= width:
		return null
	if y < 0 or y >= height:
		return null
	return nodes[x][y]
