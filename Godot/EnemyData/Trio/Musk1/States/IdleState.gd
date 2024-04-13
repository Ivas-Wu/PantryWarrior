class_name idle_state_musk1
extends State

signal jump
signal run

var musk1 : musk1

func _ready():
	musk1 = get_tree().get_first_node_in_group("Boss")
	set_physics_process(false)
	
func _enter_state() -> void:
	# Add and check queued actions
	musk1.current_animation_sprite = musk1.idle;
	musk1.idle.visible = true
	musk1.animation_player.play("Idle")
	set_physics_process(true)

func _exit_state() -> void:
	musk1.idle.visible = false
	set_physics_process(false)

func _physics_process(delta):
	musk1.handle_enemy_finder()
	handle_state()
	
func handle_state():
	if musk1.movement_cd.time_left > 0:
		pass
	elif musk1.attack_cd.time_left > 0:
		run.emit() #dodge mode
	else:
		run.emit()
