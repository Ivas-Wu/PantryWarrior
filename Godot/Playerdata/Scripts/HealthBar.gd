extends Container

@onready var heart_animation_scene: PackedScene = load("res://Collectibles/Heart/heart_animation.tscn")

func set_health_bar(hp: int):
	var current_count : int = 0
	for n in get_children():
		remove_child(n)
		n.queue_free()
		
	for n in ceil(float(hp)/100):
		var heart:  = heart_animation_scene.instantiate()
		heart.centered = false
		heart.offset.x = current_count * 20
		add_child(heart)
		current_count += 1
