extends Node2D

@onready var player = $Player
var stages = [
	#["res://World/Stage/World/stage1.tscn"], #0
	#["res://World/Stage/World/musk1stage.tscn"], #1
	["res://World/Stage/World/kingstage.tscn"], #2
	["res://World/Stage/1Stage.tscn"], #3
	["res://World/Stage/1Stage.tscn"], #4
	["res://World/Stage/1Stage.tscn"], #5
	["res://World/Stage/1Stage.tscn"], #6
	["res://World/Stage/1Stage.tscn"], #7
	["res://World/Stage/1Stage.tscn"], #8
	["res://World/Stage/1Stage.tscn"], #9
]
var stage_number = 0

func _on_next_stage_body_entered(body):
	get_tree().change_scene_to_file(stages[0][0])

