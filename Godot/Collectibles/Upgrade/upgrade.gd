extends Area2D

func _on_body_entered(body):
	if not body is Player: return
	body.gain_exp(100)
	queue_free()
