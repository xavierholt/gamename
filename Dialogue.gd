extends Label

enum Mode {
	SHOW,
	WAIT,
	HIDE
}

var Conversation = load("res://Conversation.gd")

var convo      = Conversation.new()
var mode       = HIDE
var index      = 0
var timer      = 0.0
var threshhold = 0.06
var string     = ""
#var options    = [
#	"I'm thinking about bacon...",
#	"Squirrel!",
#	"Blah blah blah blah",
#	"I miss showering."
#]

func _ready():
	var s = convo.next()
	begin_show(s)

func begin_show(s):
	mode = SHOW
	get_parent().show()
	text       = ""
	threshhold = 0.07
	timer      = 0.0
	index      = 0
	string     = s

func begin_wait():
	mode = WAIT
	threshhold = 1.5
	timer      = 0.0
	
func begin_hide():
	mode = HIDE
	get_parent().hide()
	text = ""
	
func _process(delta):
	timer += delta
	if timer >= threshhold:
		if mode == SHOW:
			text  += string[index]
			timer -= threshhold
			index += 1
			if index >= len(string):
				begin_wait()
		else:
			var s = convo.next()
			if s != null:
				begin_show(s)
			else:
				begin_hide()
