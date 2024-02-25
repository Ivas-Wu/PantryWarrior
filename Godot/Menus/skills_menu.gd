extends Control
@onready var open = $Skills/Open
@onready var menu = $Skills/Menu

var player : Player

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	open.show()
	menu.hide()
	set_physics_process(false)

func _on_close_pressed():
	menu.hide()
	open.show()

func _on_open_menu_pressed():
	menu.show()
	open.hide()

func _on_jump_sub_pressed():
	if player.skill_handler.agility > 0:
		player.skill_handler.agility -= 1

func _on_jump_add_pressed():
	if player.skill_handler.agility < 5:
		player.skill_handler.agility += 1

func _on_attack_sub_pressed():
	if player.skill_handler.offense > 0:
		player.skill_handler.offense -= 1

func _on_attack_add_pressed():
	if player.skill_handler.offense < 5:
		player.skill_handler.offense += 1

func _on_defense_sub_pressed():
	if player.skill_handler.defense > 0:
		player.skill_handler.defense -= 1

func _on_denfense_add_pressed():
	if player.skill_handler.defense < 5:
		player.skill_handler.defense += 1

func _on_dash_sub_pressed():
	if player.skill_handler.dash > 0:
		player.skill_handler.dash -= 1

func _on_dash_add_pressed():
	if player.skill_handler.dash < 5:
		player.skill_handler.dash += 1

func _on_plummet_sub_pressed():
	if player.skill_handler.special > 0:
		player.skill_handler.special -= 1

func _on_plummet_add_pressed():
	if player.skill_handler.special < 5:
		player.skill_handler.special += 1

#func _on_time_sub_pressed():
	#if player.skill_handler.ult > 0:
		#player.skill_handler.ult -= 1
#
#func _on_time_add_pressed():
	#if player.skill_handler.ult < 5:
		#player.skill_handler.ult += 1
