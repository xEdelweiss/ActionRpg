extends CharacterBody2D


const ACCELERATION = 700.0
const MAX_SPEED = 120.0
const FRICTION = 1000.0
const JUMP_VELOCITY = -40000.0

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/idle/blend_position", input_vector)
		animation_tree.set("parameters/run/blend_position", input_vector)
		animation_state.travel("run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_slide()
