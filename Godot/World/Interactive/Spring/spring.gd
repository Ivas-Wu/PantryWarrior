class_name spring
extends RigidBody2D

@export var flip: bool = false
@onready var animatable_body_2d = $AnimatableBody2D
@onready var trigger = $Trigger
@onready var animation_player = $AnimationPlayer
var body : base_character_class

func _ready():
	set_direction()

func _physics_process(delta):
	pass
	
func set_direction():
	if flip:
		animatable_body_2d.scale.x *= -1
		trigger.scale.x *= -1
	
func spring():
	if body:
		body.handle_push(Vector2(0,-500))

func _on_trigger_body_entered(player):
	animation_player.play("bounce")
	body = player

func _on_trigger_body_exited(player):
	if body == player:
		body = null
