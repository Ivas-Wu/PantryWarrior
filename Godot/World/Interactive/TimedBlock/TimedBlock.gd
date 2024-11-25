class_name timed_block
extends StaticBody2D

@export var time: float = 1
@export var reset_time: float = 99

@onready var timer = $Timer
@onready var reset = $Reset

@onready var animation_player = $AnimationPlayer

func _on_trigger_body_entered(body):
	animation_player.play("shake")
	timer.wait_time = time if time > 0 else 0.1
	timer.start()

func _on_timer_timeout():
	animation_player.play("crumble")
	reset.wait_time = reset_time if reset_time > 0 else 0.1
	reset.start()

func _on_reset_timeout():
	animation_player.play("reset")
