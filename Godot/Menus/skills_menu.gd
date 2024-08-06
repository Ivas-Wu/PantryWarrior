#extends Control
#@onready var open = $Skills/Open
#@onready var menu = $Skills/Menu
#
##Labels
#@onready var jump = $Skills/Menu/GridContainer/Scale/Jump
#@onready var attack = $Skills/Menu/GridContainer/Scale/Attack
#@onready var defense = $Skills/Menu/GridContainer/Scale/Defense
#@onready var dash = $Skills/Menu/GridContainer/Scale/Dash
#@onready var special = $Skills/Menu/GridContainer/Scale/Special
#
#var player : Player
#
#func _ready():
	#player = get_tree().get_first_node_in_group("Player")
	#open.show()
	#menu.hide()
	#init()
	#set_physics_process(false)
#
#func init():
	#for j in range(0, player.skill_handler.agility):
		#jump.text[j * 3] = 'o'
	#for a in range(0, player.skill_handler.offense):
		#attack.text[a * 3] = 'o'
	#for d in range(0, player.skill_handler.defense):
		#defense.text[d * 3] = 'o'
	#for da in range(0, player.skill_handler.dash):
		#dash.text[da * 3] = 'o'
	#for sp in range(0, player.skill_handler.special):
		#special.text[sp * 3] = 'o'
#
#func handle_stat_changes():
	#player.calculate_character_stats()
	#player.set_health_bar()
	#
#func _on_close_pressed():
	#menu.hide()
	#open.show()
	#handle_stat_changes()
#
#func _on_open_menu_pressed():
	#menu.show()
	#open.hide()
#
#func add_dash_text(index: int, idx: int):
	#match idx:
		#0:	
			#jump.text[index * 3] = '-'
		#1:	
			#attack.text[index * 3] = '-'
		#2:	
			#defense.text[index * 3] = '-'
		#3:	
			#dash.text[index * 3] = '-'
		#4:	
			#special.text[index * 3] = '-'
#
#func add_o_text(index: int, idx: int):
	#match idx:
		#0:	
			#jump.text[(index - 1) * 3] = 'o'
		#1:	
			#attack.text[(index - 1) * 3] = 'o'
		#2:	
			#defense.text[(index - 1) * 3] = 'o'
		#3:	
			#dash.text[(index - 1) * 3] = 'o'
		#4:	
			#special.text[(index - 1) * 3] = 'o'
	#
#func _on_jump_sub_pressed():
	#if player.skill_handler.sub_point(0):
		#add_dash_text(player.skill_handler.agility, 0)
#
#func _on_jump_add_pressed():
	#if player.skill_handler.add_point(0):
		#add_o_text(player.skill_handler.agility, 0)
#
#func _on_attack_sub_pressed():
	#if player.skill_handler.sub_point(1):
		#add_dash_text(player.skill_handler.offense, 1)
#
#func _on_attack_add_pressed():
	#if player.skill_handler.add_point(1):
		#add_o_text(player.skill_handler.offense, 1)
#
#func _on_defense_sub_pressed():
	#if player.skill_handler.sub_point(2):
		#add_dash_text(player.skill_handler.defense, 2)
#
#func _on_denfense_add_pressed():
	#if player.skill_handler.add_point(2):
		#add_o_text(player.skill_handler.defense, 2)
#
#func _on_dash_sub_pressed():
	#if player.skill_handler.sub_point(3):
		#add_dash_text(player.skill_handler.dash, 3)
#
#func _on_dash_add_pressed():
	#if player.skill_handler.add_point(3):
		#add_o_text(player.skill_handler.dash, 3)
#
#func _on_special_sub_pressed():
	#if player.skill_handler.sub_point(4):
		#add_dash_text(player.skill_handler.special, 4)
#
#func _on_special_add_pressed():
	#if player.skill_handler.add_point(4):
		#add_o_text(player.skill_handler.special, 4)
