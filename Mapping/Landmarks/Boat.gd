extends Node

func _ready():
	get_node("EnterArea").connect('body_entered', self, 'enter')
	get_node("LeaveArea").connect('body_entered', self, 'leave')

func enter(body):
	if not "character" in body: return
	get_node("/root/Game").play_conversation("ocean")

func leave(body):
	if not "character" in body: return
	# TODO: Pause character movement.
	get_node("/root/Game").play_conversation("boat")
