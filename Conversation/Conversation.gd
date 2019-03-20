var Line = load("res://Conversation/Line.gd")

var lines = []
var index = 0

var ending   = null
var maximums = {}
var minimums = {}

var time = 0

var pools = ["walk"]
var stats = {}
var opens = []
var locks = []

func _init(data):
	for linedata in data.lines:
		var line = Line.new(linedata)
		lines.push_back(line)
		time += line.time()
	if "ending" in data:
		ending = data["ending"]
	else:
		lines.push_back(Line.new({"text": "", "wait": 3}))
	if "maximums" in data: maximums = data["maximums"]
	if "minimums" in data: minimums = data["minimums"]
	if "pools" in data: pools = data["pools"]
	if "stats" in data: stats = data["stats"]
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

func update_stats(smap):
	for stat in stats:
		smap.add(stat, stats[stat])