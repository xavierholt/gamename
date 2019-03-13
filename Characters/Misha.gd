extends KinematicBody2D

var animator
var direction = Vector2(0, 0)
var character = true

func _ready():
	animator = get_node("AnimatedSprite")

func animate(d):
	if d == direction: return
	direction = d
	
	if direction.length() < 0.5:
		animator.playing = false
		animator.frame   = 0
		return
	animator.playing = true
	
	if animator.animation == 'walk-north':
		if direction.y < 0: return
	elif animator.animation == 'walk-east':
		if direction.x > 0: return
	elif animator.animation == 'walk-south':
		if direction.y > 0: return
	elif animator.animation == 'walk-west':
		if direction.x < 0: return
	
	if direction.y < 0:
		animator.animation = 'walk-north'
	elif direction.x > 0:
		animator.animation = 'walk-east'
	elif direction.y > 0:
		animator.animation = 'walk-south'
	else:
		animator.animation = 'walk-west'

func _process(delta):
	var d = Vector2(0, 0)
	if Input.is_action_pressed('ui_up'):
		d.y -= 1
	if Input.is_action_pressed('ui_right'):
		d.x += 1
	if Input.is_action_pressed('ui_down'):
		d.y += 1
	if Input.is_action_pressed('ui_left'):
		d.x -= 1
	move_and_slide(d * 190)
	animate(d)
