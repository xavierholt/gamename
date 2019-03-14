var pools = {}
var stats = {}

func _init():
	pass

func add(conversation):
	for pool in conversation.pools:
		if not pool in pools:
			pools[pool] = {}
		pools[pool][conversation] = true

func del(conversation):
	for pool in pools:
		pools[pool].erase(conversation)
	lock(conversation.key)

func get(pool, stats):
	# TODO: Time constraints!
	if not pool in pools:
		print("No such pool: " + pool)
		return null
	var options = []
	for conversation in pools[pool]:
		if conversation.available(stats):
			options.push_back(conversation)
	return options[randi() % len(options)]
