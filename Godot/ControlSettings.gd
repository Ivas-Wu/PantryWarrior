extends Control

@onready var grid_container = $NinePatchRect/VBoxContainer/HBoxContainer/GridContainer
@onready var video_stream_player = $NinePatchRect/ParentContainer/MiddleContainer/ScrollContainer/Control/VBoxContainer/Video/VideoStreamPlayer
@onready var labels = $NinePatchRect/ParentContainer/MiddleContainer/ScrollContainer/Control/Labels/Labels

var selected_control : control_button = null
var options = []
var options_len = 0
var idx = 0

func _ready():
	set_process(false)
	set_physics_process(false)
	
func open():
	set_process(true)
	show()
	populate_options()
	if options_len > 0:
		switch_selected()
	if selected_control:
		set_selected_control_values()

func close():
	set_process(false)
	hide()

func populate_options():
	options = labels.get_children()
	options_len = len(options)
	idx = 0
		
func set_selected_control_values():
	selected_control.select()
	
	#update video that is playing
	var video_stream_theora = VideoStreamTheora.new()
	video_stream_theora.file = selected_control.get_video_string()
	video_stream_player.stream = video_stream_theora
	video_stream_player.play()
	
	#TODO update controls that are showing that are mapped

func _process(delta):
	if Input.is_action_just_pressed("Up") and idx > 0:
		idx -= 1
		switch_selected()
	if Input.is_action_just_pressed("Down") and idx < options_len - 1:
		idx += 1
		switch_selected()
		
func switch_selected():
	if selected_control:
		selected_control.unselect()
	selected_control = options[idx]
	set_selected_control_values()
