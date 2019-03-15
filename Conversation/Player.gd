extends Panel

enum Mode {
	SHOW,
	WAIT,
	HIDE
}

var conversation = null
var line         = null

var dialog
var portrait

var mode      = HIDE
var index     = 0
var timer     = 0.0
var threshold = 0.06

func _ready():
	portrait = get_node("Portrait")
	dialog   = get_node("Dialog")

func play(conversation):
	self.conversation = conversation
	self.line = conversation.next()
	begin_show()

func begin_show():
	if not line.text:
		begin_wait()
		self.hide()
		return
	if line.character:
		var f = line.face
		var c = line.character
		var path = "res://Characters/" + c + "/Faces/" +f + ".png"
		portrait.texture = load(path)
	mode        = SHOW
	dialog.text = ""
	threshold   = line.ping
	timer       = 0.0
	index       = 0
	self.show()

func begin_wait():
	mode        = WAIT
	threshold   = line.wait
	timer       = 0.0

func begin_hide():
	mode        = HIDE
	dialog.text = ""
	self.hide()

func _process(delta):
	timer += delta
	if timer >= threshold:
		if mode == SHOW:
			if index < len(line.text):
				dialog.text += line.text[index]
				timer -= threshold
				index += 1
			else:
				begin_wait()
		elif conversation:
			line = conversation.next()
			if line:
				begin_show()
			elif conversation.ending:
				get_node("/root/Game").ending(conversation.ending)
			else:
				begin_hide()
