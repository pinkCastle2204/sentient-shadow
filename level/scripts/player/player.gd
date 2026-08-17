extends CharacterBody2D

@onready var timer: Timer = $Timer
@onready var collision_shape_2d_ofplayer: CollisionShape2D = $CollisionShape2D
@onready var checkpoint_manager: Node = $"../checkpointManager"

var SPEED = 500.0
const JUMP_VELOCITY = -700.0
@export var health = 100
@onready var collision_shape_2d: CollisionShape2D = $AttackArea/CollisionShape2D
@onready var collision_shape_2d_2: CollisionShape2D = $AttackArea/CollisionShape2D2
@onready var hitbox: HitBox = $AttackArea
@onready var hurtbox: HurtBox = $HurtArea
@export var player_inte = false
var dead = false

@export var inv : Inv
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var attacking = false
var jumpeda = false
@export var attackDamage: int
func die():
	
	animated_sprite_2d.play("death")
	
	dead = true
	timer.start()
	

func _physics_process(delta: float) -> void:
	if dead:
		return
	if health <= 0 && !dead:
		
		die()
		return
	if Input.is_action_just_pressed("attack") and !attacking and is_on_floor():
		animated_sprite_2d.play("attack")
		
		attacking = true
		SPEED = 000.0
	if Input.is_action_just_pressed("attack") and !attacking and !is_on_floor():
		animated_sprite_2d.play("attack 2")
		attacking = true
		SPEED = 000.0
	if Input.is_action_just_released("attack"):
		collision_shape_2d.disabled = true
		collision_shape_2d_2.disabled = true
		attacking = false
		SPEED = 500.0
		
			
	
	# Add the gravity.
	if not is_on_floor():
		if jumpeda == false:
			jumpeda = true
			animated_sprite_2d.play("jump")
		else:
			velocity += get_gravity() * delta
	else:
		jumpeda = false
			

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	if direction == 0 && !attacking && !jumpeda:
		animated_sprite_2d.play("default")
	elif !attacking && !jumpeda:
		animated_sprite_2d.play("run")
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if player_inte:
		velocity.x = 0
		velocity.y = 0
	move_and_slide()
	

func _on_hurt_area_damaged(hitbox: Variant) -> void:
	health -= hitbox.damage


func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.animation == "attack":
		if animated_sprite_2d.frame == 3 or animated_sprite_2d.frame == 4 or animated_sprite_2d.frame == 7 or animated_sprite_2d.frame == 13:
			if animated_sprite_2d.flip_h:
				collision_shape_2d.disabled = true
				collision_shape_2d_2.disabled = false
			else:
				collision_shape_2d.disabled = false
				collision_shape_2d_2.disabled = true
		else:
			collision_shape_2d.disabled = true
			collision_shape_2d_2.disabled = true

	elif animated_sprite_2d.animation == "attack 2":
		if animated_sprite_2d.frame == 2:
			if animated_sprite_2d.flip_h:
				collision_shape_2d.disabled = true
				collision_shape_2d_2.disabled = false
			else:
				collision_shape_2d.disabled = false
				collision_shape_2d_2.disabled = true
		else:
			collision_shape_2d.disabled = true
			collision_shape_2d_2.disabled = true
	else:
		collision_shape_2d.disabled = true
		collision_shape_2d_2.disabled = true
		
func collect(item):
	inv.insert(item)
func removeitems(item):
	inv.removeALL(item)
	


func _on_timer_timeout() -> void:
	global_position = checkpoint_manager.last_location
	health = 100
	dead = false
	

	
