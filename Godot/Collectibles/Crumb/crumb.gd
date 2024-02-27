extends Area2D

signal complete

func _on_body_entered(body):
	if not body is Player: return
	complete.emit()
	queue_free()
