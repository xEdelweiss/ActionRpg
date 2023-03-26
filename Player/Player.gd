extends CharacterBody2D


const ACCELERATION = 700.0
const MAX_SPEED = 120.0
const FRICTION = 1000.0
const JUMP_VELOCITY = -40000.0

@onready var animation_player = $AnimationPlayer

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			animation_player.play("run_right")
		else:
			animation_player.play("run_left")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_player.play("idle_right")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_slide()
