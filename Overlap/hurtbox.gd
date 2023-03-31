extends Area2D

class_name Hurtbox

const hit_effect_scene = preload("res://Effects/hit_effect.tscn")

@onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

var invincible = false:
	set(value):
		invincible = value
		if invincible:
			emit_signal("invincibility_started")
		else:
			emit_signal("invincibility_ended")

func start_invincibility(duration_sec):
	invincible = true
	timer.start(duration_sec)

func create_hit_effect():
	var effect = hit_effect_scene.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_timer_timeout():
	invincible = false

func _on_invincibility_started():
	set_deferred("monitoring", false)

func _on_invincibility_ended():
	monitoring = true
