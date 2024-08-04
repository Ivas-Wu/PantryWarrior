extends Control

@export var game: world

@onready var skills_card = $Skills/Menu/SkillsCard
@onready var skills_card_2 = $Skills/Menu/SkillsCard2
@onready var skills_card_3 = $Skills/Menu/SkillsCard3
@onready var menu = $Skills/Menu

var player : Player

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	set_physics_process(false)
	hide()
	setup()
	
func setup():
	skills_card.set_text("Testing")
	skills_card_2.set_text("Testing")
	skills_card_3.set_text("Testing")
	skills_card.pressed.connect(select_ability.bind(1))
	skills_card_2.pressed.connect(select_ability.bind(2))
	skills_card_3.pressed.connect(select_ability.bind(3))
	player.level_handler.leveled.connect(open.bind())
	
func _process(delta):
	pass
	
func select_ability(index: int):
	#TODO
	hide()
	get_tree().paused = false

func open():
	get_tree().paused = true
	#TODO
	show()
	
