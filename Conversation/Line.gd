var character
var face = "default"
var text

var ping = 0.07
var wait = 1.50
var hide = 0.00

func _init(data):
	text = data.text
	if "char" in data: character = data["char"]
	if "face" in data: face = data["face"]
	if "ping" in data: ping = data["ping"]
	if "wait" in data: wait = data["wait"]
	if "hide" in data: hide = data["hide"]

func time():
	return ping * len(text) + wait
