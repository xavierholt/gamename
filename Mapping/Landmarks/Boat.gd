extends Node

func _ready():
	get_node("EnterArea").connect('body_entered', self, 'enter')
	get_node("LeaveArea").connect('body_entered', self, 'leave')

func enter(body):
	if not "character" in body: return
	get_node("/root/Game").play_conversation("ocean")

func leave(body):
	if not "character" in body: return
	get_node("/root/Game/GUI").set_pause_mode(PAUSE_MODE_PROCESS)
	get_node("/root/Game/Minimap").set_pause_mode(PAUSE_MODE_STOP)
	get_node("/root/Game").play_conversation("boat")
	get_tree().paused = true
