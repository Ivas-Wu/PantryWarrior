class_name control_button
extends Control

#Predefined label text and video strings mapped for label types in component
@export var label_type: StringName
@onready var label = $NinePatchRect/HBoxContainer/LabelSpacer/Label
@onready var nine_patch_rect = $NinePatchRect

var selected : bool = false #visual thing
var regular_texture : CompressedTexture2D = load('res://Playerdata/Controls/test.png')
var selected_texture : CompressedTexture2D = load('res://Playerdata/Controls/test2.png')

# label text
var label_texts_enum = {
	input_stringname.Up : "Up/Jump",
	input_stringname.Down : "Down/Drop",
	input_stringname.Left : "Left",
	input_stringname.Right : "Right",
}

# video location
var video_enum = {
	input_stringname.Up : "res://Playerdata/Controls/replicate-prediction-3mub6kbbgiftidugvney3e53ay.ogv",
	input_stringname.Down : "res://Playerdata/Controls/replicate-prediction-3mub6kbbgiftidugvney3e53ay.ogv",
	input_stringname.Left : "res://Playerdata/Controls/replicate-prediction-3mub6kbbgiftidugvney3e53ay.ogv",
	input_stringname.Right : "res://Playerdata/Controls/replicate-prediction-3mub6kbbgiftidugvney3e53ay.ogv",
}

func _ready():
	set_process(false)
	set_physics_process(false)
	
	#Create label settings
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 7
	label.label_settings.font_color = Color(1, 1, 1, 1)
	
	if label_type:
		set_label_text()
	
func set_label_text():
	label.text = get_label_string()

func get_label_string() -> String:
	return label_texts_enum[label_type] if label_type in label_texts_enum else ''
	
func get_video_string() -> String:
	return video_enum[label_type] if label_type in video_enum else ''

func get_keybinds(action: StringName) -> Array[InputEvent]:
	return InputMap.action_get_events(action)
	
func select():
	selected = true
	nine_patch_rect.texture = selected_texture
	label.label_settings.font_color = Color(0, 0, 0, 1)
	
func unselect():
	selected = false
	nine_patch_rect.texture = regular_texture
	label.label_settings.font_color = Color(1, 1, 1, 1)

func enter_select_keys_mode():
	pass
