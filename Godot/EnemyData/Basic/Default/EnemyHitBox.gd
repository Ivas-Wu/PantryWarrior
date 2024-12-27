class_name EnemyHitBox
extends hitbox_base

func _ready():
	collision_layer = 128
	collision_mask = 64
	init()
	
func _process(delta):
	pass
