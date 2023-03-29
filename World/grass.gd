extends Node2D


func _on_hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()

func create_grass_effect():
	var grass_effect_scene = load("res://Effects/grass_effect.tscn") as PackedScene
	var grass_effect = grass_effect_scene.instantiate() as Node2D
	grass_effect.global_position = global_position
	
	var world = get_tree().current_scene
	world.add_child(grass_effect)
