extends Sprite

func _on_Area2D_body_entered(body):
	body.kill_zone_touched()
