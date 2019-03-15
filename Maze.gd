extends Node

var Conversation = load("res://Conversation/Conversation.gd")
var StatMap = load("res://Conversation/StatMap.gd")
var Pools = load("res://Conversation/Pools.gd")

var MapNode = load("res://Mapping/PathNode.gd")
var Map = load("res://Mapping/PathMap.gd")

var misha
var andrew
var killi

var map
var pools
var stats

func hookup(a, b, dir):
	a.neighbors[dir] = b
	b.neighbors[(dir + 2) % 4] = a
	var src = a.tile.get_node("YSort")
	var dst = get_node("Map/YSort")
	for child in src.get_children():
		var pos = child.get_global_position()
		src.remove_child(child)
		child.position.x += 3200 * a.x
		child.position.y += 3200 * a.y
		dst.add_child(child)

func _ready():
	randomize()
	var w = 2
	var h = 2
	map = Map.new(w, h)
	pools = Pools.new()
	stats = StatMap.new()
	load_conversations("res://Conversation/Data/")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# Connect the clubhouse:
	var cnode = MapNode.new(map, -1, 0)
	cnode.tile = get_node("Map/Clubhouse")
	hookup(cnode, map.node(0, 0), 1)
	
	# Connect the boat:
	var bnode = MapNode.new(map, w, h-1)
	bnode.tile = get_node("Map/BoatTile")
	hookup(bnode, map.node(w-1, h-1), 3)
	bnode.tile.position.x = 3200 *  w
	bnode.tile.position.y = 3200 * (h - 1)
	
	# Fix up the map / minimap:
	get_node("Map/PathTile").setup(map.node(0, 0))
	var minimap = get_node("Minimap/Map")
	minimap.visit(map.node(0, 0), 1)
	minimap.visit(cnode, 2)
	
	# Party time!
	misha  = get_node("Map/YSort/Misha")
	andrew = get_node("Map/YSort/Andrew")
	killi  = get_node("Map/YSort/Killi")
	andrew.leader = misha
	killi.leader  = andrew
	auto_conversation("walk")

func auto_conversation(pool):
	var panel = get_node("GUI/Panel")
	if panel.line: return
	
	var c = pools.get(pool, stats)
	if not c: return
	
	c.update_stats(stats)
	panel.play(c)
	pools.del(c)

func play_conversation(pool):
	var panel = get_node("GUI/Panel")
	var c = pools.get(pool, stats)
	if not c: return
	
	c.update_stats(stats)
	panel.play(c)
	pools.del(c)

func load_conversations(path):
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true, true)
	
	var fn = "."
	while fn != "":
		fn = dir.get_next()
		print("Checkin' out " + path + fn)
		if fn.get_extension() == "json":
			var file = File.new()
			file.open(path + fn, file.READ)
			var result = JSON.parse(file.get_as_text())
			if result.error == OK:
				var cn = fn.get_basename()
				var c = Conversation.new(result.result)
				pools.add(c)
				continue
			print("Error in " + path + fn + "!")
			print(" - Line " + str(result.error_line) + ":  " + result.error_string)
	dir.list_dir_end()

func _process(delta):
	if Input.is_action_just_pressed("ui_map"):
		var minimap = get_node("Minimap/Map")
		if not minimap.visible:
			var misha = get_node("Map/YSort/Misha")
			get_tree().paused = true
			minimap.urhere(misha)
			minimap.show()
		else:
			get_tree().paused = false
			minimap.hide()

func ending(name):
	get_node("Splash/Sunset").show()
	get_tree().paused = true