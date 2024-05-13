extends Node2D

@onready var player = $Player
var stage = "res://World/Stage/home.tscn"

func _on_next_stage_body_entered(body):
	get_tree().change_scene_to_file(stage)
