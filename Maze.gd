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
	var killi  = get_node("Map/YSort/Killi")
	killi.leader  = andrew
	andrew.leader = misha
	
	auto_conversation("walk")

func auto_conversation(pool):
	var panel = get_node("GUI/Panel")
	if panel.line: return
	
	var c = pools.get(pool, stats)
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
			print("Error in " + path + fn + " line " + result.error_line)
			print(" - Error:  ", result.error)
			print(" - String: ", result.error_string)
	dir.list_dir_end()
