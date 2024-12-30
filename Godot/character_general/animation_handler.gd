class_name animation_handler
extends Node

@export var character : base_character_class

func _ready():
	set_process(false)

# Maybe set a reoccuring check against the chacater to ensure only one sprite is active? Very process heavy
func _process(delta):
	pass

func get_current_sprite(default = null):
	return character.current_sprite if character.current_sprite else default
	
func set_current_sprite(sprite):
	var current = get_current_sprite()
	var flipped  = false
	if current:
		current.visible = false
		
		flipped = current.flip_h
		character.current_sprite = sprite
		character.current_sprite.flip_h = flipped
	else:
		character.current_sprite = sprite
		
	get_current_sprite().visible = true
	
	return flipped
