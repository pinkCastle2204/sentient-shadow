extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@export var player: CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export	var direction := 1
func near(b:float,c: float) -> bool:
		var a = abs(c-b);
		if(a < 50):
			if((c < b and player.animated_sprite_2d.flip_h == false) or (c > b and player.animated_sprite_2d.flip_h == true)):
				return true
			else:
				return false
		return false
	
		
func _physics_process(delta: float) -> void:
	
	if (player.attacking == true) and near(global_position.x,player.global_position.x):
		animated_sprite_2d.play("hit")
		velocity.x = 0
		return
	else:
		animated_sprite_2d.play("default")
	# Add the gravity.
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if ray_cast_2d_2.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
	if ray_cast_2d.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
