extends Control

func _input(event):
	if event.is_action_pressed("grapple"):
		get_tree().change_scene("res://Level00.tscn")
