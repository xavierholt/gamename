extends Sprite

export (String) var leader_name

var leader   = null
var velocity = Vector2(0, 0)

func _ready():
	leader = get_node("../" + leader_name)

func _process(delta):
	var v = leader.position - position
	velocity *= 0.9
	if v.length_squared() > 1000:
		velocity += 0.09 * v.normalized()
	position += velocity
