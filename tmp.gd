extends StaticBody2D


func _draw():
	print("drawing collision shape")
	draw_line(Vector2(0,0), Vector2(500,500), Color(1.0, 1.0, 1.0))
