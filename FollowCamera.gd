extends Camera2D

export(bool) var x_follow = false
export(bool) var y_follow = false

export(float) var velocity_leading_factor = 5.0

var target
var target_last_position

func _ready():
	target_last_position = position
	update_position()

func update_target():
	if target and is_instance_valid(target):
		return
	else:
		target = null
		var players = get_tree().get_nodes_in_group("player")
		if players:
			target = players[0]
			target_last_position = target.position
		else:
			print("no player found")


func _process(delta):
	update_position()

func update_position():
	update_target()
	if target:
		var target_frame_velocity = (target.position - target_last_position) * velocity_leading_factor

		if x_follow:
			position.x = target.position.x + target_frame_velocity.x

		if y_follow:
			position.y = target.position.y + target_frame_velocity.y

		target_last_position = target.position
