extends Control

func _input(event):
	if event.is_action_pressed("ui_end"):
		get_tree().change_scene("res://MainMenu.tscn")
