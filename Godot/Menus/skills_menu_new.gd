extends Control

@export var game: world

@onready var menu = $Skills/Menu

var player : Player
var card_count : int = 3
const skill_card_path = "res://Menus/skills_card.tscn"
var selected_index = 0
var cards : Array

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	set_physics_process(false)
	#hide()
	setup()
	open()
	
func setup():
	var skills = player.skill_handler.get_skills(card_count)
	for s in skills:
		var skills_card = preload(skill_card_path).instantiate().with_values(s[2], s[1], s[0])
		get_node("Skills/Menu").add_child(skills_card)
		skills_card.pressed.connect(select_ability.bind(s[0]))
		if cards.is_empty():
			skills_card.selected = true
		cards.append((skills_card))

	player.level_handler.leveled.connect(open.bind()) #Opens upon leveling only, TODO
	
func _process(delta):
	if Input.is_action_just_pressed("Left"):
		cards[selected_index].selected = false
		if selected_index == 0:
			selected_index = 0
		else: selected_index -= 1
		cards[selected_index].selected = true
	if Input.is_action_just_pressed("Right"):
		cards[selected_index].selected = false
		selected_index = (selected_index + 1)%card_count
		cards[selected_index].selected = true
	if Input.is_action_just_pressed("Confirm"):
		cards[selected_index].pressed.emit()
	
func select_ability(idx: int):
	player.skill_handler.add_ability(idx)
	hide()
	get_tree().paused = false

func open():
	get_tree().paused = true
	#TODO
	show()
	
