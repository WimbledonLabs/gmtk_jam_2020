extends Polygon2D

export(NodePath) onready var collision_polygon = get_node(collision_polygon)

# Called when the node enters the scene tree for the first time.
func _ready():
	print(polygon)
	set_polygon(collision_polygon.polygon)
	print(polygon)
