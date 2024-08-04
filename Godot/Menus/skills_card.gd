class_name skill_card
extends Control

@onready var text_edit = $TextEdit
@onready var icon = $TextureRect

var new_texture = preload("res://icon.svg")

signal pressed

func _ready():
	pass

func _process(delta):
	pass

func set_text(text: String):
	text_edit.text = text
	
func set_icon(new_icon):
	icon.texture = new_icon

func _on_button_pressed():
	pressed.emit()
