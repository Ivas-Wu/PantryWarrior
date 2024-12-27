class_name generic_enemy_attack_state
extends State

var attacking: bool = false

signal aggro

@onready var actor = $"../.." as generic_enemy
	
func _ready():
	set_physics_process(false)
	
func _enter_state() -> void:
	actor.animation_player.play("Attack")
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	actor.velocity = Vector2.ZERO
	actor.move_and_slide()
