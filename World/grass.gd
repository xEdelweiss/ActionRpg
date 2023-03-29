extends Node2D

const grass_effect_scene: PackedScene = preload("res://Effects/grass_effect.tscn")

func _on_hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()

func create_grass_effect():
	var grass_effect = grass_effect_scene.instantiate() as Node2D
	get_parent().add_child(grass_effect)
	grass_effect.global_position = global_position
