class_name enemy_spawner
extends Node

@export var enemy_type : int = -1
@export var total_count : int = -1

#Enemy Types
var enemy_types = [
				preload("res://EnemyData/Basic/Default/enemy.tscn"), # 1
				preload("res://EnemyData/Basic/Spear/spear.tscn"), # 2
			]

var list_of_enemies : Array = []
var list_of_regions : Array = []
var region_weight : float = 0
var rng = RandomNumberGenerator.new()

func _ready():
	if enemy_type > 0 and total_count > 0:
		populate_regions_list()
		populate_enemy_list()
		spawn()

func populate_regions_list():
	for _i in self.get_children():
		if _i is navigation_properties and _i.spawn_weighting > 0 and _i.max_spawns > 0:
			list_of_regions.append(_i)
			region_weight += _i.spawn_weighting

func populate_enemy_list(): #only supports 2 type(s) at a time right now
	match enemy_type:
		1:
			list_of_enemies.append(enemy_types[0])
		2:
			list_of_enemies.append(enemy_types[1])

func spawn():
	if not list_of_enemies.is_empty():
		for i in range(total_count):
			var region = choose_region()
			if region:
				create_enemy(list_of_enemies[0], region.global_position)

func choose_region() -> navigation_properties:
	var val = rng.randf()
	var iterator: float = 0
	for r in list_of_regions:
		iterator += r.spawn_weighting
		if iterator/region_weight >= val:
			r.max_spawns -= 1
			if r.max_spawns == 0:
				region_weight -= r.spawn_weighting
				r.spawn_weighting = 0
				list_of_regions.remove_at(list_of_regions.find(r))
			else:
				var reduction = r.spawn_weighting * 0.3
				region_weight -= reduction
				r.spawn_weighting -= reduction
			return r
	return null

func create_enemy(enemy: PackedScene, location: Vector2):
	var ene = enemy.instantiate()
	get_node("../../Enemies").add_child(ene)
	ene.global_position = location
	
func _process(delta):
	pass
