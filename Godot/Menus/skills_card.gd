class_name skill_card
extends Control

@onready var text_edit = $VBoxContainer/DescriptionContainer/description
@onready var display_icon = $VBoxContainer/IconContainer/icon
@onready var color_rect = $ColorRect

var skill_index : int = -1

var new_texture = "res://icon.svg"
var selected = false:
	get:
		return selected
	set(value):
		selected = value
		if selected:
			color_rect.color = Color(1, 1, 1, 0.4)
		else:
			color_rect.color = Color(0, 0, 0, 0.2)

signal pressed

func _ready():
	pass

func with_values(text: String = "", icon = new_texture, index: int = -1):
	#run without _ready
	text_edit = $VBoxContainer/DescriptionContainer/description
	display_icon = $VBoxContainer/IconContainer/icon
	text_edit.text = "[center]" + text + "[/center]"
	display_icon.texture = load(icon)
	skill_index = index
	return self	

#func _on_button_pressed():
	#pressed.emit()	
