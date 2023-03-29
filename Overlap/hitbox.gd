extends Area2D

@onready var collision_shape = $CollisionShape2D

func _ready():
	collision_shape.disabled = true
