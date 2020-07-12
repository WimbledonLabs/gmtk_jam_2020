extends Node2D

var nodes_to_clean_up = []

var rope_end
var rope_body_start

func attach(body_a, body_b, attach_position):
	rope_body_start = body_a
	rope_end = attach_position
	if nodes_to_clean_up:
		detach()

	var distance = (body_a.position - attach_position).length()
	var segment_count = 4
	var segment_length = distance / segment_count

	var start_position = attach_position
	var segment_vector = (body_a.position - attach_position).normalized() * segment_length

	var segments = []

	var pin_previous = body_b
	for segment_num in range(segment_count):
		var link = load("res://RopeLink.tscn").instance()
		link.resize(segment_length)
		link.position = start_position + segment_vector * segment_num
		link.rotate(segment_vector.angle() - PI/2)

		add_child(link)
		nodes_to_clean_up.append(link)

		link.pin.set_node_b(pin_previous.get_path())

		pin_previous = link.body

	var last_pin = PinJoint2D.new()

	add_child(last_pin)
	nodes_to_clean_up.append(last_pin)

	last_pin.position = body_a.position
	last_pin.set_node_a(body_a.get_path())
	last_pin.set_node_b(pin_previous.get_path())

	#get_tree().paused = true


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
