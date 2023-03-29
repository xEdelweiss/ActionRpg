extends CharacterBody2D


@export var ACCELERATION = 700.0
@export var MAX_SPEED = 120.0
@export var FRICTION = 1000.0
@export var JUMP_VELOCITY = -40000.0
@export var ROLL_SPEED = 100.0

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var roll_vector = Vector2.DOWN

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
@onready var sword_hitbox = $HitboxPivot/SwordHitbox

func _ready():
	animation_tree.active = true
	sword_hitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE: move_state(delta)
		ATTACK: attack_state(delta)
		ROLL: roll_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		update_direction(input_vector)
		
		animation_state.travel("run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func attack_state(delta):
	# velocity = Vector2.ZERO # this should fix slide on attack, but I do not have this bug
	animation_state.travel("attack")
	
func attack_animation_finished():
	state = MOVE
	
func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animation_state.travel("roll")
	move_and_slide()
	
func roll_animation_finished():
	state = MOVE
	
func update_direction(input_vector):
	roll_vector = input_vector
	sword_hitbox.knockback_vector = roll_vector
		
	animation_tree.set("parameters/idle/blend_position", input_vector)
	animation_tree.set("parameters/run/blend_position", input_vector)
	animation_tree.set("parameters/attack/blend_position", input_vector)
	animation_tree.set("parameters/roll/blend_position", input_vector)
