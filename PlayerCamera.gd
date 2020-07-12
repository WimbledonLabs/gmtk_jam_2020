extends Camera2D

export(NodePath) onready var target = get_node(target)

var target_last_position

func _ready():
	# Start with the target at the center of the screen so that there's not a
	# weird pan when entering the scene
	target_last_position = target.position
	position = target.position

func _process(delta):
	assert(target)
	var target_frame_velocity = target.position - target_last_position
	position = target.position + target_frame_velocity

	target_last_position = target.position
