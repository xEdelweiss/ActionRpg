extends Node2D

class_name WanderController

@export var wander_range: int = 32

@onready var start_position = global_position
@onready var target_position = global_position
@onready var timer = $Timer

func _ready():
	update_target_position()

func update_target_position():
	var target_vector = Vector2(randi_range(-wander_range, wander_range), randi_range(-wander_range, wander_range))
	target_position = start_position + target_vector

func get_time_left():
	return timer.time_left
	
func start_timer(duration_sec):
	timer.start(duration_sec)

func _on_timer_timeout():
	update_target_position()
