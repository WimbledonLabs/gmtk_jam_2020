extends Node2D

export(String) onready var next_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	# Spawn the rope first, since the player needs it on ready
	add_child(load("res://Rope.tscn").instance())

	_spawn_player()

func _handle_goal_reached():
	if next_scene:
		get_tree().change_scene(next_scene)
	else:
		get_tree().reload_current_scene()

func _handle_player_died():
	_spawn_player()

func _spawn_player():
	# Always start player a half pixel to the side to fix sprite rendering issue
	var spawn_location = get_tree().get_nodes_in_group("player_spawn")[0].position + Vector2(0.5, 0)

	var player = load("res://Player.tscn").instance()
	player.position = spawn_location

	add_child(player)
	player.connect("goal_reached", self, "_handle_goal_reached")
	player.connect("died", self, "_handle_player_died")
