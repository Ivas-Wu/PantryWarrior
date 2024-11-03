extends Control

@onready var grid_container = $NinePatchRect/VBoxContainer/HBoxContainer/GridContainer
@onready var video_stream_player = $NinePatchRect/ParentContainer/MiddleContainer/ScrollContainer/Control/VBoxContainer/Video/VideoStreamPlayer
@onready var labels = $NinePatchRect/ParentContainer/MiddleContainer/ScrollContainer/Control/Labels/Labels
@onready var keys = $NinePatchRect/ParentContainer/MiddleContainer/ScrollContainer/Control/VBoxContainer/Keys

@onready var key_display = $NinePatchRect/ParentContainer/MiddleContainer/ScrollContainer/Control/VBoxContainer/Keys/KeyDisplay
@onready var key_display_2 = $NinePatchRect/ParentContainer/MiddleContainer/ScrollContainer/Control/VBoxContainer/Keys/KeyDisplay2
@onready var key_display_3 = $NinePatchRect/ParentContainer/MiddleContainer/ScrollContainer/Control/VBoxContainer/Keys/KeyDisplay3
@onready var key_display_4 = $NinePatchRect/ParentContainer/MiddleContainer/ScrollContainer/Control/VBoxContainer/Keys/KeyDisplay4

@onready var key_grabber = $KeyGrabber

var select_keys_mode : bool = false # 0 is default 1 is select keys

var selected_control : control_button = null
var selected_key : key_button = null
var options = []
var options_len = 0
var control_idx = 0
var key_idx = 0

func _ready():
	set_process(false)
	set_physics_process(false)
	key_grabber.key_grabbed.connect(set_key)
	
func open():
	set_process(true)
	show()
	populate_options()
	if options_len > 0:
		switch_selected_control()
	if selected_control:
		set_selected_control_values()

func close():
	set_process(false)
	hide()

func populate_options():
	options = labels.get_children()
	options_len = len(options)
	control_idx = 0
		
func set_selected_control_values():
	selected_control.select()
	
	#update video that is playing
	var video_stream_theora = VideoStreamTheora.new()
	video_stream_theora.file = selected_control.get_video_string()
	video_stream_player.stream = video_stream_theora
	video_stream_player.play()
	
	#TODO update controls that are showing that are mapped
	update_key_display()

func update_key_display():
	var key_array = [key_display,
				key_display_2,
				key_display_3,
				key_display_4]
	var keys_to_load = selected_control.get_keybinds(selected_control.label_type)
	for i in range(4):
		if i < len(keys_to_load):
			key_array[i].set_label_details(keys_to_load[i], selected_control.label_type)
		else:
			key_array[i].set_empty_key()
			
func _process(delta):
	if !select_keys_mode:
		if Input.is_action_just_pressed(input_stringname.Up) and control_idx > 0:
			control_idx -= 1
			switch_selected_control()
		if Input.is_action_just_pressed(input_stringname.Down) and control_idx < options_len - 1:
			control_idx += 1
			switch_selected_control()
	else:
		if Input.is_action_just_pressed(input_stringname.Left) and key_idx > 0:
			key_idx -= 1
			switch_selected_key()
		if Input.is_action_just_pressed(input_stringname.Right) and key_idx < options_len - 1:
			key_idx += 1
			switch_selected_key()
	if Input.is_action_just_pressed(input_stringname.Confirm) and selected_control:
		if !select_keys_mode:
			selected_control.enter_select_keys_mode()
			select_keys_mode = true
			switch_selected_key()
		else:
			selected_key.enter_set_key_mode()
			key_grabber.open()
		
func switch_selected_control():
	if selected_control:
		selected_control.unselect()
	selected_control = options[control_idx]
	set_selected_control_values()

func switch_selected_key():
	if selected_key:
		selected_key.unselect()
	selected_key = keys.get_children()[key_idx]
	selected_key.select()

func set_key(key: InputEventKey): 
	selected_key.update_keybind(key)
	update_key_display()
