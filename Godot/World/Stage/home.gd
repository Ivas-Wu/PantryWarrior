class_name home
extends stage_base

var stages = [
	"res://World/Stage/World/stage2.tscn", #0
	"res://World/Stage/World/musk1stage.tscn", #1
	"res://World/Stage/World/kingstage.tscn", #2
	"res://World/Stage/1Stage.tscn", #3
	"res://World/Stage/1Stage.tscn", #4
	"res://World/Stage/1Stage.tscn", #5
	"res://World/Stage/1Stage.tscn", #6
	"res://World/Stage/1Stage.tscn", #7
	"res://World/Stage/1Stage.tscn", #8
	"res://World/Stage/1Stage.tscn", #9
]

func _on_next_stage_body_entered(body):
	var stage_number: int = scene_tracker.scene_number
	scene_tracker.scene_number = stage_number + 1
	if stage_number <= len(stages):
		get_tree().change_scene_to_file(stages[stage_number])
	else:
		return #game is deadlocked if it reaches here make a work around

