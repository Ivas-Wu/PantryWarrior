class_name projectile_base
extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready(): pass
func _process(delta): pass	
func destroy():
	queue_free()

