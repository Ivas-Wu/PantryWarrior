class_name defend_state_king
extends State

signal attack

var king : king

func _ready():
	king = get_tree().get_first_node_in_group("Boss")
	set_physics_process(false)
	
func _enter_state() -> void:
	set_physics_process(true)
	king.idle_attack.visible = true
	king.character_animations.play("AttackIdle")
	form_shield()

func _exit_state() -> void:
	king.push_area.disabled = true
	king.idle_attack.visible = false
	break_shield()
	set_physics_process(false)

func _physics_process(delta):
	if not king.in_safety:
		break_shield()

func form_shield():
	king.temp_shield.visible = true
	king.defense_animation.play("ShieldForming")

func shield_formed(): pass
	
func break_shield():
	king.defense_animation.play("ShieldBreaking")
	
func shield_broke():
	king.temp_shield.visible = false
	attack.emit()
