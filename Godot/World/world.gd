class_name world
extends Node

@export var stage : Node

signal toggle_game_paused(is_paused: bool)
var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

signal stage_complete()
	
func _ready():
	if stage:
		stage.stage_complete.connect(complete_stage)

func _process(_delta):
	pass

func _input(event : InputEvent):
	if(event.is_action_pressed("Pause")):
		game_paused = not game_paused

func complete_stage(): 
	get_tree().paused = true
	stage_complete.emit()
	
func navigate():
	get_tree().change_scene_to_file("res://World/Stage/World/home.tscn")
