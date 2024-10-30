extends Control

@export var label_text: String

@onready var label = $HBoxContainer/Label

func _ready():
	label.text = label_text

func _process(delta):
	pass
