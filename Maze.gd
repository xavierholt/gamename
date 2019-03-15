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

func _ready():
	randomize()
	pools = Pools.new()
	stats = StatMap.new()
	load_conversations("res://Conversation/Data/")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# Connect to the main map:
	map = Map.new(10, 10)
	var enode = map.node(0, 0)
	var cnode = MapNode.new(map, -1, 0)
	cnode.tile = get_node("Map/Clubhouse")
	enode.neighbors[3] = cnode
	cnode.neighbors[1] = enode
	get_node("Map/PathTile").setup(map.node(0, 0))
	
	# Fix up the minimap:
	var minimap = get_node("Minimap/Map")
	minimap.visit(cnode, 2)
	minimap.visit(enode, 1)
	
	# Transfer trees to the main map:
	var src = get_node("Map/Clubhouse/YSort")
	var dst = get_node("Map/YSort")
	for child in src.get_children():
		src.remove_child(child)
		child.position.x -= 3200
		dst.add_child(child)
	
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
