class_name HitBox
extends hitbox_base

@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	collision_layer = 32
	collision_mask = 256
	collision_shape_2d.disabled = true
	init()
	
func _process(delta):
	pass
