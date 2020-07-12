extends Control

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_end"):
		back_to_main_menu()

func back_to_main_menu():
	get_tree().change_scene("res://MainMenu.tscn")
