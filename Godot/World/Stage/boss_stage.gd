class_name boss_stage
extends Node

@onready var player = $Player
signal stage_complete()

func _on_end_stage_body_entered(body):
	player.gain_exp(200) #need to make calculation here to balance this stat
	stage_complete.emit()
