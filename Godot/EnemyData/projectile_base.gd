class_name projectile_base
extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var enemy_hit_box = $EnemyHitBox/CollisionShape2D

func _ready(): pass
func _process(delta): pass	
func destroy():
	enemy_hit_box.disabled = true
	collision_shape_2d.disabled = true
	sprite_2d.visible = false
	queue_free()

