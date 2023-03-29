extends AnimatedSprite2D

func _ready():
	connect("animation_finished", self._on_animation_finished)
	play("animate")

func _on_animation_finished():
	queue_free()
