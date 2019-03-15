extends Area2D

func _input_event(viewport, event, shape):
	if event is InputEventMouseButton and event.is_pressed():
		print("Click!")
		var scene = load("res://Trees/Scenes/AnyTree.tscn")
		var thing = scene.instance()
		thing.position = get_global_mouse_position() * 4
		get_parent().get_node("YSort").add_child(thing)
