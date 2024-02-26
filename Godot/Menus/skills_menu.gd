extends Control
@onready var open = $Skills/Open
@onready var menu = $Skills/Menu

#Labels
@onready var jump = $Skills/Menu/GridContainer/Scale/Jump
@onready var attack = $Skills/Menu/GridContainer/Scale/Attack
@onready var dash = $Skills/Menu/GridContainer/Scale/Dash
@onready var special = $Skills/Menu/GridContainer/Scale/Special
@onready var defense = $Skills/Menu/GridContainer/Scale/Defense

var player : Player

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	open.show()
	menu.hide()
	init()
	set_physics_process(false)

func init():
	for j in range(0, player.skill_handler.agility):
		jump.text[j * 3] = 'o'
	for a in range(0, player.skill_handler.offense):
		attack.text[a * 3] = 'o'
	for d in range(0, player.skill_handler.defense):
		defense.text[d * 3] = 'o'
	for da in range(0, player.skill_handler.dash):
		dash.text[da * 3] = 'o'
	for sp in range(0, player.skill_handler.special):
		special.text[sp * 3] = 'o'

func handle_stat_changes():
	player.calculate_character_stats()
	player.set_health_bar()
	
func _on_close_pressed():
	menu.hide()
	open.show()
	handle_stat_changes()

func _on_open_menu_pressed():
	menu.show()
	open.hide()

func _on_jump_sub_pressed():
	if player.skill_handler.agility > 0:
		player.skill_handler.agility -= 1
		jump.text[player.skill_handler.agility * 3] = '-'

func _on_jump_add_pressed():
	if player.skill_handler.agility < 5:
		jump.text[player.skill_handler.agility * 3] = 'o'
		player.skill_handler.agility += 1

func _on_attack_sub_pressed():
	if player.skill_handler.offense > 0:
		player.skill_handler.offense -= 1
		attack.text[player.skill_handler.offense * 3] = '-'

func _on_attack_add_pressed():
	if player.skill_handler.offense < 5:
		attack.text[player.skill_handler.offense * 3] = 'o'
		player.skill_handler.offense += 1

func _on_defense_sub_pressed():
	if player.skill_handler.defense > 0:
		player.skill_handler.defense -= 1
		defense.text[player.skill_handler.defense * 3] = '-'

func _on_denfense_add_pressed():
	if player.skill_handler.defense < 5:
		defense.text[player.skill_handler.defense * 3] = 'o'
		player.skill_handler.defense += 1

func _on_dash_sub_pressed():
	if player.skill_handler.dash > 0:
		player.skill_handler.dash -= 1
		dash.text[player.skill_handler.dash * 3] = '-'

func _on_dash_add_pressed():
	if player.skill_handler.dash < 5:
		dash.text[player.skill_handler.dash * 3] = 'o'
		player.skill_handler.dash += 1

#func _on_time_sub_pressed():
	#if player.skill_handler.ult > 0:
		#player.skill_handler.ult -= 1
#
#func _on_time_add_pressed():
	#if player.skill_handler.ult < 5:
		#player.skill_handler.ult += 1special


func _on_special_sub_pressed():
	if player.skill_handler.special > 0:
		player.skill_handler.special -= 1
		special.text[player.skill_handler.special * 3] = '-'

func _on_special_add_pressed():
	if player.skill_handler.special < 5:
		special.text[player.skill_handler.special * 3] = 'o'
		player.skill_handler.special += 1
