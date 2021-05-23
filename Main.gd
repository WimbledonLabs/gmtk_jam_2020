extends RigidBody2D

var mouse_down = false
var mouse_position = Vector2()

var grappling = false
var grapple_objects = []

var rope
export(float) var max_grapple_distance = 50

signal died()
signal goal_reached()

func _ready():
	rope = get_tree().get_nodes_in_group("rope")[0]
	assert(rope)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			mouse_down = true

		elif event.button_index == BUTTON_LEFT and not event.pressed:
			mouse_down = false

	if event is InputEventScreenTouch:
		event = event as InputEventScreenTouch
		if event.pressed:
			attempt_grapple()
		else:
			release_grapple()

	if event.is_action_pressed("grapple"):
		attempt_grapple()

	if event.is_action_released("grapple"):
		release_grapple()

	if event.is_action_released("ui_restart"):
		death_animation_finished()


func attempt_grapple():
	assert(rope)
	var target = find_best_grapple_target()
	if not target:
		return

	# The parent of a target is always the physics object to attach to
	rope.attach(self, target.get_parent(), target.global_position)
	$hook_sound.play()

	grappling = true


func release_grapple():
	# Always detach the rope
	assert(rope)
	rope.detach()

	# Only play this if we're absolutely sure we were grappling
	if grappling:
		$release_sound.play()

	grappling = false


# Optionally returns the best target, if one is close enough to grapple to
func find_best_grapple_target():
	var grapple_targets = get_tree().get_nodes_in_group("grapple_targets")
	var best_target
	var best_target_score = 0

	for target in grapple_targets:
		# TODO: visualize relative scores so that players know when it will switch (they won't be too screwed by changing best targets)
		var score = target_score(target)
		if score > best_target_score:
			best_target = target
			best_target_score = score

	return best_target


# Return negative if the target isn't close enough
func target_score(grapple_target) -> float:
	var grapple_position = grapple_target.global_position
	var distance_to_target = self.position.distance_to(grapple_position)

	var score = 1.0 / distance_to_target
	if distance_to_target > max_grapple_distance:
		return 0.0

	return score


func _physics_process(delta):
	if mouse_down:
		pass #apply_central_impulse((get_global_mouse_position() - position))


func goal_touched():
	emit_signal("goal_reached")


func kill_zone_touched():
	$player.play("death")
	mode = RigidBody2D.MODE_KINEMATIC

func death_animation_finished():
	emit_signal("died")
	queue_free()

func _process(delta):
	# Queues redraw (for some reason)
	update()

func _draw():
	#get_parent().draw_line(Vector2(0,0), Vector2(500,500), Color(0.5,0.5,0.5))
	if not grappling:
		var target = find_best_grapple_target()
		if target:
			draw_line(Vector2(0,0), to_local(target.global_position), Color(0xd9a06655))
