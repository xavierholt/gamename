var map
var x
var y

var visited   = 0
var neighbors = [null, null, null, null]
var parent    = self
var tile      = null

func _init(map, x, y):
	self.map = map
	self.x   = x
	self.y   = y

func arity():
	var count = 0
	for n in neighbors:
		if n: count += 1
	return count

func bits():
	var count = 0
	if neighbors[0]: count += 1
	if neighbors[1]: count += 2
	if neighbors[2]: count += 4
	if neighbors[3]: count += 8
	return count

func distance(direction):
	if arity() != 2:
		return 0
	for i in range(4):
		if i == direction:
			continue
		var next = neighbors[i]
		if next:
			var d = (i + 2) % 4
			return next.distance(d)
	print("Distance calculation gone awry...")
	return 0

func endpoint(direction):
	if arity() != 2:
		return self
	for i in range(4):
		if i == direction:
			continue
		var next = neighbors[i]
		if next:
			var d = (i + 2) % 4
			return next.endpoint(d)
	print("Endpoint calculation gone awry...")
	return self

func root():
	if parent == self:
		return self
	parent = parent.root()
	return parent

func union(other):
	var sroot = self.root()
	var oroot = other.root()
	if sroot == oroot:
		return false
	oroot.parent = sroot
	return true
