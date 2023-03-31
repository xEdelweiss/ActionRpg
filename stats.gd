extends Node

class_name Stats

signal health_changed(value)
signal max_health_changed(value)
signal no_health

@export var max_health: int = 1:
	set(value):
		max_health = value
		emit_signal("max_health_changed", max_health)
		
		if health == null:
			health = max_health
		else:
			health = min(health, max_health)
	
var health:
	set(value):
		health = clamp(value, 0, max_health)
		emit_signal("health_changed", health)
		if health <= 0:
			emit_signal("no_health")

