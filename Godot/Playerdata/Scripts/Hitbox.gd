class_name HitBox
extends Area2D

@export var damage: int
@export var stun_time : float
@export var knock_back : int

func _ready():
	collision_layer = 32
	monitorable = false
	monitoring = false

func _process(delta):
	pass
