class_name damaged_state_king
extends State

signal finished

var king : king

func _ready():
	king = get_tree().get_first_node_in_group("Boss")
	set_physics_process(false)
	
func _enter_state() -> void:
	king.damaged.visible = true
	king.character_animations.play("Damaged")
	king.attack_animations.play("Push")
	await(king.handle_time_slow(0.1))
	set_physics_process(true)

func _exit_state() -> void:
	king.damaged.visible = false
	king.invul = false
	set_physics_process(false)

func _physics_process(_delta):
	pass
	
func handle_state(): 
	finished.emit()
