class_name EnemyHurtBox
extends Area2D
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	collision_layer = 256
	collision_mask = 32
	collision_shape_2d.disabled = false

func _process(delta):
	pass
