extends Area2D

@export var show_hit = true
const hit_effect_scene = preload("res://Effects/hit_effect.tscn")

func _on_area_entered(area):
	if not show_hit:
		return
		
	var effect = hit_effect_scene.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position
