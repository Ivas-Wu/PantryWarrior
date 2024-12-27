extends Control

@export var input : StringName
@export var override : String
@onready var label = $NinePatchRect/BoxContainer/Label

var keybinds

var label_texts_enum = {
	input_stringname.Up : "Jump",
	input_stringname.Down : "Drop",
	input_stringname.Left : "Left",
	input_stringname.Right : "Right",
	input_stringname.Attack : "Attack",
}

func _ready():
	if override:
		label.text = override
	else:
		keybinds = InputMap.action_get_events(input)
		if input and len(keybinds) > 0:
			label.text = "To " + label_texts_enum[input] + " press: '" + keybinds[0].as_text_physical_keycode() + "'"

func _process(delta):
	pass
