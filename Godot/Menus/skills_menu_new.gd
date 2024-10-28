extends Control

const skill_card_path = "res://Menus/skills_card.tscn"

@export var game: world

@onready var menu = $Skills/Menu

var player : Player
var card_count : int = 3
var selected_index = 0
var cards : Array
var currently_open : bool = false
var banked : Array = []

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	set_process(false)
	#hide()
	setup()
	#open([2]) #For testing only, upon loading in
	
func open(level_queue: Array):
	if level_queue.is_empty() : return
	set_process(true)
	get_tree().paused = true
	if currently_open: banked.append_array(level_queue) #This does nothing, bug with multiple levels still exists
	currently_open = true
	cards = []
	
	var level = level_queue.pop_front()
	banked.append_array(level_queue)
	
	var skills: Array = player.skill_handler.get_skills(card_count, level if level <= player.skill_handler.max_level else player.skill_handler.max_level)
	if skills.is_empty(): close()
	for s in skills:
		var skills_card = preload(skill_card_path).instantiate().with_values(s[3][0], s[3][1], s[2], s[0])
		get_node("Skills/Menu").add_child(skills_card)
		skills_card.pressed.connect(select_ability.bind(s[0]))
		if cards.is_empty():
			skills_card.selected = true
		cards.append((skills_card))
	show()
	
func setup():
	player.level_handler.leveled.connect(open) #Opens upon leveling only, TODO
	
func _process(delta):
	if Input.is_action_just_pressed("Left"):
		switch_selected(card_count - 1 if selected_index == 0 else selected_index - 1)
	if Input.is_action_just_pressed("Right"):
		switch_selected((selected_index + 1)%card_count)
	if Input.is_action_just_pressed("Confirm"):
		cards[selected_index].pressed.emit()

func switch_selected(new_index):
	cards[selected_index].selected = false
	selected_index = new_index
	cards[selected_index].selected = true
	
func select_ability(idx: int):
	player.skill_handler.add_ability(idx, true)
	cleanup()
	
func cleanup():
	switch_selected(0)
	for c in get_node("Skills/Menu").get_child_count():
		var child = get_node("Skills/Menu").get_child(c)
		child.queue_free()
	close()
	
func close():
	hide()
	set_process(false)
	currently_open = false
	if banked.is_empty():
		get_tree().paused = false
	else:
		open([banked.pop_front()])
	
