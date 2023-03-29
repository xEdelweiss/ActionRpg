extends CharacterBody2D

const KNOCKBACK_FORCE = 200.0
const FRICTION = 500.0

var knockback = Vector2.ZERO

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = knockback
	move_and_slide()

func _on_hurtbox_area_entered(area):
	if "knockback_vector" in area:
		knockback = area.knockback_vector * KNOCKBACK_FORCE
