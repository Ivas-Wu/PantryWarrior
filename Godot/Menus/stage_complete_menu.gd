extends Control

@export var game: world

func _ready():
	hide()	 
	game.stage_complete.connect(_end_stage)
	
func _process(delta):
	pass

func _end_stage():
	show()
	
func _on_continue_pressed():
	game.game_paused = false
	game.navigate()

func _on_exit_pressed():
	return

func _on_save_pressed():
	return

