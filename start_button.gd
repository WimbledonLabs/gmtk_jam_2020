extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus()


func _on_start_button_pressed():
	get_tree().change_scene("res://Level.tscn")
