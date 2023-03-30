extends CharacterBody2D

const ACCELERATION = 1800.0
const MAX_SPEED = 150
const FRICTION = 20.0
const KNOCKBACK_FORCE = 200.0
const KNOCKBACK_FRICTION = 500.0

const enemy_death_effect_scene: PackedScene = preload("res://Effects/enemy_death_effect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var knockback = Vector2.ZERO
var state = IDLE

@onready var stats: Stats = $Stats
@onready var sprite = $AnimatedSprite2D
@onready var detection_zone = $PlayerDetectionZone as PlayerDetectionZone
@onready var detection_zone_area = $PlayerDetectionZone/CollisionShape2D as CollisionShape2D

func _ready():
	print(str("health: ", stats.health))
	print(str("max_health: ", stats.max_health))

func _physics_process(delta):
	var previous_velocity = velocity
	knockback = knockback.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	velocity = knockback
	
	match state:
		IDLE: 
			detection_zone_area.debug_color = Color(1, 0, 0, 0)
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER: 
			detection_zone_area.debug_color = Color(1, 0, 0, 0.1)
		CHASE: 
			detection_zone_area.debug_color = Color(1, 0, 0, 0.4)
			var player = detection_zone.player as CharacterBody2D
			if player != null:
				var direction_to_player = global_position.direction_to(player.global_position)				
				velocity = velocity.move_toward(direction_to_player * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
		
	move_and_slide()
		
func seek_player():
	if detection_zone.can_see_player():
		state = CHASE

func _on_hurtbox_area_entered(area):
	if (area is SwordHitbox):
		knockback = area.knockback_vector * KNOCKBACK_FORCE
		(stats as Stats).health -= area.damage

func _on_stats_no_health():
	queue_free()
	var enemy_death_effect = enemy_death_effect_scene.instantiate()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position
