extends KinematicBody2D

var animator
var direction = Vector2(0, 0)
var velocity  = Vector2(0, 0)
var character = true
var leader    = null

func _ready():
	animator = get_node("AnimatedSprite")

func lead(d):
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

func follow():
	if velocity.length_squared() < 0.5:
		animator.playing = false
		animator.frame   = 0
		return
	animator.playing = true
	
	if abs(velocity.x) < abs(velocity.y):
		if velocity.y < 0:
			animator.animation = 'walk-north'
		else:
			animator.animation = 'walk-south'
	elif velocity.x < 0:
		animator.animation = 'walk-west'
	else:
		animator.animation = 'walk-east'

func set_leader(l):
	leader = l
	var cam = get_node("Camera2D")
	var col = get_node("CollisionShape2D")
	cam.current  = (l == null)
	col.disabled = (l != null)

func _process(delta):
	if leader:
		var v = leader.position - position
		velocity *= 0.9
		if v.length_squared() > 30000:
			velocity += 0.5 * v.normalized()
		position += velocity
		follow()
	else:
		var d = Vector2(0, 0)
		if Input.is_action_pressed('ui_up'):
			d.y -= 1
		if Input.is_action_pressed('ui_right'):
			d.x += 1
		if Input.is_action_pressed('ui_down'):
			d.y += 1
		if Input.is_action_pressed('ui_left'):
			d.x -= 1
		velocity = d * 190
		move_and_slide(velocity)
		lead(d)
