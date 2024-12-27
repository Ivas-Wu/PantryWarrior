class_name home
extends stage_base

var stages = [
	"res://World/Stage/World/tutorialStage1.tscn",
	"res://World/Stage/World/musk1stage.tscn",
	"res://World/Stage/World/tutorialStage2.tscn",
	"res://World/Stage/World/kingstage.tscn",
	"res://World/Stage/World/stage1.tscn",
	"res://World/Stage/World/stage2.tscn",
	"res://World/Stage/1Stage.tscn",
	"res://World/Stage/1Stage.tscn",
	"res://World/Stage/1Stage.tscn",
	"res://World/Stage/1Stage.tscn",
]

func _on_next_stage_body_entered(body):
	var stage_number: int = scene_tracker.scene_number
	scene_tracker.scene_number = stage_number + 1
	if stage_number <= len(stages):
		get_tree().change_scene_to_file(stages[stage_number])
	else:
		return #game is deadlocked if it reaches here make a work around

