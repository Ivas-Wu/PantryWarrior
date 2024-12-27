class_name generic_enemy_damaged_state
extends State

signal out

@onready var actor = $"../.." as generic_enemy

func _ready():
	set_physics_process(false)
	
func _enter_state() -> void:
	actor.invulnerability_frames = 30
	actor.animation_player.play("Damaged")
	actor.hurt_box_col.set_deferred("disabled", true)
	set_physics_process(true)

func _exit_state() -> void:
	actor.hurt_box_col.set_deferred("disabled", false)
	set_physics_process(false)

func _physics_process(delta):
	if actor.invulnerability_frames == 0:
		out.emit()
	actor.move_and_slide()
