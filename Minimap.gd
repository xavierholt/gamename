extends Node

func urhere(misha):
	var sprite = get_node("Points/Player")
	sprite.position = misha.position / 3200 * 50
	sprite.rotation = randf() * 0.6 - 0.3

func visit(node, amount):
	if amount <= node.visited:
		return
	node.visited = amount
	var paths  = get_node("Paths")
#	var points = get_node("Points")
	if amount >= 2:
		paths.set_cell(node.x, node.y, node.bits())
		# TODO: Point of interest markers.
	elif amount >= 1:
		paths.set_cell(node.x, node.y, 16 + randi() % 8)

func _process(delta):
	if Input.is_action_just_pressed("ui_map"):
		var minimap = get_node("Minimap/Map")
		if not minimap.visible:
			var misha = get_node("Map/YSort/Misha")
			get_tree().paused = true
			minimap.urhere(misha)
			minimap.show()
		else:
			get_tree().paused = false
			minimap.hide()
