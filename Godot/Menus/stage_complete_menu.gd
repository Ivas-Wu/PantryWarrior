extends Control

@export var game: world
var player : Player

func _ready():
	set_process(false)
	hide()	 
	game.stage_complete.connect(_end_stage)
	player = get_tree().get_first_node_in_group("Player")
	
func _process(delta):
	pass

func _end_stage():
	set_process(true)
	show()

func save() :
	player.save_game.save()
	
func _on_continue_pressed():
	save()
	game.game_paused = false
	game.navigate()

func _on_exit_pressed():
	save()
	get_tree().quit()

func _on_save_pressed():
	save()
