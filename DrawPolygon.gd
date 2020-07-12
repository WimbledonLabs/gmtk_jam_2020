extends CollisionPolygon2D

func _draw():
	var colors = []
	for p in polygon:
		colors.append(Color(0xd9a066ff))
	draw_polygon(polygon, colors)
