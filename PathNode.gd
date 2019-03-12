var map
var x
var y

var neighbors = [null, null, null, null]
var parent = self
var tile   = null

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
