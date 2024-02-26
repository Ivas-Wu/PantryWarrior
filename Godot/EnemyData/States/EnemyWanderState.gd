class_name enemy_wander_state
extends State

signal found
signal stopped
signal jump

@onready var actor = $"../.." as Enemy

var prev_position : Vector2

func _ready():
	set_physics_process(false)
	
func _enter_state() -> void:
	set_physics_process(true)
	actor.direction.x = 1 if actor.current_direction else -1
	actor.animated_sprite_2d.play("Idle")
	actor.speed *= 0.5

func _exit_state() -> void:
	set_physics_process(false)
	actor.speed *= 2

func _physics_process(delta):
	prev_position = actor.global_position
	handle_state_changes()
	if is_stuck():
		actor.current_direction = 0 if actor.current_direction else 1
		actor.direction.x = 1 if actor.current_direction else -1
	actor.move_and_slide()
	
func handle_state_changes():
	if actor.handle_enemy_finder():
		found.emit()
	else:
		if actor.random_number > 0.9:
			actor.velocity = Vector2.ZERO
			stopped.emit()

func is_stuck():
	if actor.movement_update_buffer.time_left == 0 && actor.is_on_wall():
		actor.movement_update_buffer.start()
		return true
