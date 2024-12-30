class_name generic_enemy_aggro_state
extends State

signal lost
signal attack
@onready var actor = $"../.." as generic_enemy
@onready var run = $"../../Run"

func _ready():
	set_physics_process(false)
	
func _enter_state() -> void:
	set_physics_process(true)
	actor.movement_update_buffer.stop()
	actor.animation_player.play("Running")
	actor.sprite_script.set_current_sprite(run)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	if not actor.handle_enemy_finder():
		handle_state_changes()
	if actor.movement_update_buffer.time_left == 0 || actor.navigation_agent_2d.is_target_reached():
		actor.direction = get_direction()
		actor.movement_update_buffer.start()
	check_aggro_range()
	var just_on_ground = actor.is_on_floor()
	actor.move_and_slide()
	if just_on_ground and not actor.is_on_floor() and actor.velocity.y >= 0:
		actor.coyote_jump_timer.start()

func get_direction() -> Vector2:
	var dir : Vector2 = actor.get_path_direction()
	var dis : float = dir.length()/actor.stat_data.vision_range
	if dis > 0.5:
		return dir if actor.random_number < 0.9 else -dir
	elif dis > 0.2:
		return dir if actor.random_number < 0.5 else -dir
	else:
		return dir if actor.random_number < 0.1 else -dir

func handle_state_changes():
	lost.emit()

func check_aggro_range():
	if actor.handle_attack_ray() and actor.attack_cd.time_left == 0:
		if actor.random_number > 0.5:
			actor.direction = actor.get_path_direction()
			attack.emit()
	
func handle_drop_aggro():
	lost.emit()
