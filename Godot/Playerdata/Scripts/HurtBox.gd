class_name HurtBox
extends Area2D

func _ready():
	collision_layer = 64
	collision_mask = 128
	monitoring = true
	monitorable = true
	
func _process(_delta):
	pass
