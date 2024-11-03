class_name key_button
extends Control

#Predefined label text and video strings mapped for label types in component
@onready var label = $NinePatchRect/HBoxContainer/LabelSpacer/Label
@onready var nine_patch_rect = $NinePatchRect

var selected : bool = false #visual thing
var regular_texture : CompressedTexture2D = load('res://Playerdata/Controls/test.png')
var selected_texture : CompressedTexture2D = load('res://Playerdata/Controls/test2.png')

var input_event: InputEvent = null
var control_action: StringName
 
func _ready():
	set_process(false)
	set_physics_process(false)
	
	#Create label settings
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 7
	label.label_settings.font_color = Color(1, 1, 1, 1)
	
func set_label_details(event: InputEvent, action_type: StringName):
	label.text = event.as_text_physical_keycode()
	input_event = event
	control_action = action_type

func set_empty_key():
	label.text = ''
	pass #TODO load empty version

func select():
	selected = true
	nine_patch_rect.texture = selected_texture
	label.label_settings.font_color = Color(0, 0, 0, 1)
	
func unselect():
	selected = false
	nine_patch_rect.texture = regular_texture
	label.label_settings.font_color = Color(1, 1, 1, 1)
	
func enter_set_key_mode():
	pass
	
func update_keybind(key: InputEventKey):
	var actions = InputMap.action_get_events(control_action)

	for a in actions:
		InputMap.action_erase_event(control_action, a)
	actions.insert(actions.find(input_event), key)
	actions.erase(input_event)
	for a in actions:
		InputMap.action_add_event(control_action, a)
