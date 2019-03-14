extends Node

var Conversation = load("res://Conversation/Conversation.gd")
var StatMap = load("res://Conversation/StatMap.gd")
var Pools = load("res://Conversation/Pools.gd")
var Map = load("res://Mapping/PathMap.gd")

var map
var pools
var stats

func _ready():
	randomize()
	pools = Pools.new()
	stats = StatMap.new()
	load_conversations("res://Conversation/Data/")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	map = Map.new(10, 10)
	get_node("Map/PathTile").setup(map.node(0, 0))
	var misha  = get_node("Map/YSort/Misha")
	var andrew = get_node("Map/YSort/Andrew")
	andrew.leader = misha
	
	auto_conversation("walk")

func auto_conversation(pool):
	var c = pools.get(pool, stats)
	get_node("GUI/Panel").play(c)

func load_conversations(path):
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	var fn = "."
	while fn != "":
		fn = dir.get_next()
		print("Checkin' out " + path + fn)
		if fn.get_extension() == "json":
			var file = File.new()
			print("Loading " + path + fn + "...")
			file.open(path + fn, file.READ)
			var result = JSON.parse(file.get_as_text())
			if result.error == OK:
				var cn = fn.get_basename()
				var c = Conversation.new(result.result)
				pools.add(c)
				continue
			print("Parse Error:  ", result.error)
			print("Error Line:   ", result.error_line)
			print("Error String: ", result.error_string)
	dir.list_dir_end()
