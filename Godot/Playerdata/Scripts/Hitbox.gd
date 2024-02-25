class_name HitBox
extends Area2D

@export var damage: int
@export var stun_time : float
@export var knock_back : int
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	collision_layer = 32
	collision_mask = 256
	collision_shape_2d.disabled = true

func _process(delta):
	pass
