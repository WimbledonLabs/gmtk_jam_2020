extends Sprite

func _on_Area2D_body_entered(body):
	print("body entered kill zone")
	body.kill_zone_touched()
