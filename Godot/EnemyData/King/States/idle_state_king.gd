class_name idle_state_king
extends State

signal defend
signal attack

var king : king

func _ready():
	king = get_tree().get_first_node_in_group("Boss")
	set_physics_process(false)
	
func _enter_state() -> void:
	king.idle.visible = true
	king.character_animations.play("Idle")
	set_physics_process(true)

func _exit_state() -> void:
	king.idle.visible = false
	set_physics_process(false)

func _physics_process(delta):
	king.handle_enemy_finder()
	handle_state()
	
func handle_state():
	if king.in_safety:
		defend.emit()
	else:
		attack.emit()
