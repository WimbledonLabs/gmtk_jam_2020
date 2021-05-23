extends Node2D

var nodes_to_clean_up = []

var rope_end
var rope_body_start
var grapple_distance

func attach(body_a, body_b, attach_position):
	rope_body_start = body_a
	rope_end = attach_position

	grapple_distance = (rope_end - rope_body_start.global_position).length()

func _physics_process(delta):
	if rope_body_start:
		var pull_vector = rope_end - rope_body_start.global_position
		if pull_vector.length() > grapple_distance:
			var linear_velocity_impulse_factor = -rope_body_start.get_linear_velocity().dot(pull_vector.normalized())
			linear_velocity_impulse_factor = clamp(linear_velocity_impulse_factor, 0.0, 500.0)
			var distance_from_ideal_impulse_factor = pull_vector.length() - grapple_distance

			var pull_strength = abs(linear_velocity_impulse_factor * distance_from_ideal_impulse_factor)
			rope_body_start.apply_central_impulse(pull_vector.normalized() * pull_strength)

func detach():
	for node in nodes_to_clean_up:
		node.queue_free()

	rope_body_start = null
	rope_end = null
	nodes_to_clean_up = []

func _process(delta):
	update()

func _draw():
	if rope_body_start and rope_end:
		var a = rope_body_start.global_position
		var b = rope_end
		draw_line(a, b, Color(1.0, 1.0, 1.0))

		draw_circle(rope_end, grapple_distance, Color(1.0, 1.0, 1.0, 0.1))
