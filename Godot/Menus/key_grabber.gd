extends Control

signal key_grabbed(key)

var just_open = false

func _ready():
	close()

func _process(delta):
	pass

func open():
	get_viewport().set_input_as_handled()
	show()
	set_process(true)
	set_process_input(true)
	just_open = true
	
func close():
	hide()
	set_process(false)
	set_process_input(false)
	
func _input(event):
	if just_open:
		just_open = false
	elif event is InputEventKey:
		get_viewport().set_input_as_handled()
		key_grabbed.emit(event)
		close()
