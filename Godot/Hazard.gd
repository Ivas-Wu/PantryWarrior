class_name Hazard
extends Area2D

@export var damage: int
@export var knock_back : int

func _ready():
	collision_layer = 4
	collision_mask = 2

func _process(delta):
	pass
