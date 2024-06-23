class_name defend_state_king
extends State

signal attack

var king : king

func _ready():
	king = get_tree().get_first_node_in_group("Boss")
	set_physics_process(false)
	
func _enter_state() -> void:
	king.idle_attack.visible = true
	king.character_animations.play("AttackIdle")
	set_physics_process(true)

func _exit_state() -> void:
	king.idle_attack.visible = false
	set_physics_process(false)

func _physics_process(delta):
	if not king.in_safety:
		attack.emit()
