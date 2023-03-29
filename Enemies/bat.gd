extends CharacterBody2D

const KNOCKBACK_FORCE = 200.0
const FRICTION = 500.0

var knockback = Vector2.ZERO

@onready var stats: Stats = $Stats

func _ready():
	print(str("health: ", stats.health))
	print(str("max_health: ", stats.max_health))

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = knockback
	move_and_slide()

func _on_hurtbox_area_entered(area):
	if (area is SwordHitbox):
		knockback = area.knockback_vector * KNOCKBACK_FORCE
		(stats as Stats).health -= area.damage

func _on_stats_no_health():
	queue_free()
