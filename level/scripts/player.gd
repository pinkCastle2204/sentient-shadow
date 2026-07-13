extends CharacterBody2D


var SPEED = 200.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var attacking = false
var jumpeda = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and !attacking and is_on_floor():
		animated_sprite_2d.play("attack")
		attacking = true
		SPEED = 150.0
	if Input.is_action_just_pressed("attack") and !attacking and !is_on_floor():
		animated_sprite_2d.play("attack 2")
		attacking = true
		SPEED = 150.0
	if Input.is_action_just_released("attack"):
		attacking = false
		SPEED = 200.0
		
			
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumpeda = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	if direction == 0 && !attacking:
		animated_sprite_2d.play("default")
	elif !attacking:
		animated_sprite_2d.play("run")
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
