extends Control

@export var game: world
var player : Player
	
func _ready():
	hide()	 
	game.toggle_game_paused.connect(_toggle_game_paused)
	player = get_tree().get_first_node_in_group("Player")
	
func _process(delta):
	pass

func _toggle_game_paused(is_paused: bool) :
	if(is_paused):
		show()
	else:
		hide()

func save() :
	player.save_game.save()
	
func _on_resume_pressed():
	game.game_paused = false

func _on_exit_pressed():
	save()
	get_tree().quit()

func _on_save_pressed():
	save()
