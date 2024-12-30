class_name generic_enemy_idle_state
extends State

signal found
signal wander

@onready var actor = $"../.." as generic_enemy
@onready var idle = $"../../Idle"

func _ready():
	set_physics_process(false)
	
func _enter_state() -> void:
	set_physics_process(true)
	actor.animation_player.play("Idle") 
	actor.sprite_script.set_current_sprite(idle)
	actor.velocity = Vector2.ZERO

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	handle_state_changes()
	actor.move_and_slide()
	
func handle_state_changes():
	if actor.handle_enemy_finder():
		found.emit()
	else:
		if actor.random_number > 0.2:
			wander.emit()
