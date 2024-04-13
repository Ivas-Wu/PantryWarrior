class_name basic_attack_state_musk1
extends State

signal idle

var musk1 : musk1

func _ready():
	musk1 = get_tree().get_first_node_in_group("Boss")
	set_physics_process(false)
	
func _enter_state() -> void:
	musk1.current_animation_sprite = musk1.basic_attack;
	musk1.basic_attack.visible = true
	musk1.animation_player.play("Basic Attack")
	set_physics_process(true)

func _exit_state() -> void:
	musk1.current_animation_sprite.visible = false
	set_physics_process(false)

func _physics_process(delta):
	pass
	
func handle_state():
	musk1.attack_cd.start()
	musk1.movement_cd.start()
	idle.emit()
