extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.play("animate")


func _on_animation_finished():
	queue_free()
