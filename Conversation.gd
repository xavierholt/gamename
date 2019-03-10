var lines = []
var index = 0

func _init():
	index = 0
	lines = [
		"I used to want to be a firefighter when I grew up.",
		"But I've always been afraid of fire.",
		"I think that's why, actually...",
		"So I coud do something about it.",
		"Fight back.",
		"But now I want to be a marine biologist.",
		"Nothing to worry about.  No fire there.",
		"I guess I was braver as a kid."
	]

func next():
	if index >= len(lines):
		return null
	var line = lines[index]
	index += 1
	return line
