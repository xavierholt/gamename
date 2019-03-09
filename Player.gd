extends KinematicBody2D

func _process(delta):
	var velocity = Vector2(0, 0)
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	get_node("AnimatedSprite").playing = (velocity.length() > 0.5)
	velocity = velocity.normalized()
	move_and_slide(velocity * 190)
