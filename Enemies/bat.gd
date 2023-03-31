extends CharacterBody2D

const ACCELERATION = 150.0
const MAX_SPEED = 50
const FRICTION = 500.0

const KNOCKBACK_FORCE = 200.0
const KNOCKBACK_FRICTION = 500.0

@export var WANDER_TARGET_RANGE = 4 # distance when target considered reached

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
@onready var hurtbox = $Hurtbox as Hurtbox
@onready var soft_collision = $SoftCollision as SoftCollision
@onready var wander_controller = $WanderController as WanderController

func _ready():
	state = pick_random_state([WANDER, IDLE])

func _physics_process(delta):
	var previous_velocity = velocity
	if knockback != Vector2.ZERO:
		knockback = knockback.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
		velocity = knockback
	
	match state:
		IDLE: 
			detection_zone_area.debug_color = Color(1, 0, 0, 0)
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wander_controller.get_time_left() == 0:
				reset_wander_timer()
		WANDER: 
			detection_zone_area.debug_color = Color(1, 0, 0, 0.1)
			seek_player()
			move_to_point(wander_controller.target_position, delta)
			if global_position.distance_to(wander_controller.target_position) <= WANDER_TARGET_RANGE:
				reset_wander_timer()
			if wander_controller.get_time_left() == 0:
				reset_wander_timer()
		CHASE: 
			detection_zone_area.debug_color = Color(1, 0, 0, 0.4)
			var player = detection_zone.player as CharacterBody2D
			if player != null:
				move_to_point(player.global_position, delta)
			else:
				state = IDLE
		
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400
		
	move_and_slide()
		
func seek_player():
	if detection_zone.can_see_player():
		state = CHASE

func move_to_point(target: Vector2, delta):
	var direction = global_position.direction_to(target)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func reset_wander_timer():
	state = pick_random_state([WANDER, IDLE])
	wander_controller.start_timer(randi_range(1, 3))

func pick_random_state(state_list: Array):
	state_list.shuffle()
	return state_list.pop_front()

func _on_hurtbox_area_entered(area):
	if (area is SwordHitbox):
		knockback = area.knockback_vector * KNOCKBACK_FORCE
		(stats as Stats).health -= area.damage
		hurtbox.create_hit_effect()

func _on_stats_no_health():
	queue_free()
	var enemy_death_effect = enemy_death_effect_scene.instantiate()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position
