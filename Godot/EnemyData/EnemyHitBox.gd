class_name EnemyHitBox
extends Area2D

@export var damage: int
@export var stun_time : float
@export var knock_back : int
var already_hit : bool = false;

func _ready():
	collision_layer = 128
	collision_mask = 64

func _process(delta):
	pass
