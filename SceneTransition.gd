extends Node2D

var scene_change_started = false

func _input(event):
	$Viewport.input(event)


func _on_scene_change(scene_path):
	if scene_change_started:
		return
	scene_change_started = true

	get_tree().paused = true

	print("Start transition to ", scene_path)
	var image = $ViewportSprite.texture.get_data()
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	$OtherSprite.texture = texture

	var queue = preload("res://resource_queue.gd").new()
	queue.start()

	print("queue")
	yield(get_tree(), "idle_frame")
	queue.queue_resource(scene_path)
	yield(get_tree(), "idle_frame")

	print("remove child")
	$Viewport.remove_child($Viewport/Level)

	print("Start tween")
	$Tween.interpolate_property($OtherSprite, "modulate", $OtherSprite.modulate, Color(0.0, 0.0, 0.0, 1.0), 0.4, Tween.TRANS_LINEAR)
	$Tween.start()
	yield($Tween, "tween_completed")
	print("stop tween")

	while not ResourceLoader.has_cached(scene_path):
		$Label.text = "%.2f" % queue.get_progress(scene_path)
		yield(get_tree(), "idle_frame")
	$Label.text = ""

	var next_level = queue.get_resource(scene_path).instance()
	next_level.set_name("Level")

	$Viewport.add_child(next_level)

	print("Start tween")
	$Tween.interpolate_property($OtherSprite, "position:x", 0, 250, 0.3, Tween.TRANS_LINEAR)
	$Tween.start()
	yield($Tween, "tween_completed")
	print("stop tween")

	$OtherSprite.position.x = 0
	$OtherSprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$OtherSprite.texture = null

	get_tree().paused = false

	next_level.connect("scene_change", self, "_on_scene_change")

	scene_change_started = false
