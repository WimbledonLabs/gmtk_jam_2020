extends Node2D

onready var pin = get_node("pin")
onready var body = get_node("body")

func _ready():
	pin.set_node_a($body.get_path())

func resize(length):
	$body/collision.shape.a = Vector2(0, 0)
	$body/collision.shape.b = Vector2(0, length)

	# By default, the sprite with scale 1 has a length of 57
	$body/sprite.scale = Vector2(0.2, length/57)

