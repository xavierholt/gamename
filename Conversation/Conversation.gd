var Line = load("res://Conversation/Line.gd")

var lines = []
var index = 0

var maximums = {}
var minimums = {}

var time = 0

var pools = ["walk"]
var opens = []
var locks = []

func _init(data):
	for linedata in data.lines:
		var line = Line.new(linedata)
		lines.push_back(line)
		time += line.time()
	if "pools" in data: pools = data["pools"]
	if "opens" in data: opens = data["opens"]
	if "locks" in data: locks = data["locks"]

func available(stats):
	for stat in maximums:
		if stats.get(stat) > maximums[stat]:
			return false
	for stat in minimums:
		if stats.get(stat) < minimums[stat]:
			return false
	return true

func next():
	if index >= len(lines):
		return null
	var line = lines[index]
	index += 1
	return line
