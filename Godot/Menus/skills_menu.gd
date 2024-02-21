extends Control
@onready var open = $Skills/Open
@onready var menu = $Skills/Menu

func _ready():
	open.show()
	menu.hide()
	set_physics_process(false)

func _on_close_pressed():
	menu.hide()
	open.show()

func _on_open_menu_pressed():
	menu.show()
	open.hide()
