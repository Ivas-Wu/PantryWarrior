extends Area2D

func _on_body_entered(body):
	if not body is Player: return
	body.heal(100)
	queue_free()
