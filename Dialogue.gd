extends Label

enum Mode {
	SHOW,
	WAIT,
	HIDE
}

var mode       = HIDE
var index      = 0
var timer      = 0.0
var threshhold = 0.07
var string     = ""
var options    = [
	"I'm thinking about bacon...",
	"Squirrel!",
	"Blah blah blah blah",
	"I miss showering."
]

func _ready():
	begin_hide()

func begin_show(s):
	mode = SHOW
	get_parent().show()
	text       = ""
	threshhold = 0.06
	timer      = 0.0
	index      = 0
	string     = s

func begin_wait():
	mode = WAIT
	threshhold = 1.0
	timer      = 0.0
	
func begin_hide():
	mode = HIDE
	get_parent().hide()
	text = ""
	
func _process(delta):
	if mode == HIDE:
		if randf() < 0.01:
			var s = options[randi() % 4]
			begin_show(s)
		return
	timer += delta
	if timer >= threshhold:
		if mode == SHOW:
			text  += string[index]
			timer -= threshhold
			index += 1
			if index >= len(string):
				begin_wait()
		else:
			begin_hide()
