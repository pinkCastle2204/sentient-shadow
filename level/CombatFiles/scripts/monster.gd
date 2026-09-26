extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var progress_bar: ProgressBar = $ProgressBar
@export var fleeMul: float = 1.0
@export var attackMul: float = 1.0

@export var MAX_HEALTH = 100.0
@export var player: CharacterBody2D
@export	var direction := 1

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var utility_brain = $UtilityBrain
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hitbox: HitBox = $AttackArea
@onready var hurtbox: HurtBox = $HurtBox
@onready var collision_shape_2d1: CollisionShape2D = $AttackArea/CollisionShape2D
@onready var collision_shape_2d_2: CollisionShape2D = $AttackArea/CollisionShape2D2

var health = 100.0
var current_action = "patrol"
var is_despawned =false

func near(b:float,c: float) -> bool:
		var a = abs(c-b);
		if(a < 50):
			if((c < b and player.animated_sprite_2d.flip_h == false) or (c > b and player.animated_sprite_2d.flip_h == true)):
				return true
			else:
				return false
		return false
func near2(b:float,c: float) -> bool:
		var a = abs(c-b);
		if(a < 250):
			if((c < b and player.animated_sprite_2d.flip_h == false) or (c > b and player.animated_sprite_2d.flip_h == true)):
				return true
			else:
				return false
		return false

func _physics_process(delta: float) -> void:
	if is_despawned:
		return
	progress_bar.value = health
	
	
	if health>0:
			
			health=clamp(health,0.0,MAX_HEALTH) 
	if health <=0:
		animated_sprite_2d.play("death")
		await animated_sprite_2d.animation_finished
		queue_free()
		
	
		
		return
	#else:
		#animated_sprite_2d.play("default")
	# Add the gravity.
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match utility_brain.curr:
		"patrol":
			patrol()
		"chase":
			chase()
		"attack":
			attack()
				
		"flee":
			flee()
	move_and_slide()
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#if ray_cast_2d_2.is_colliding():
		#direction = -1
		#animated_sprite_2d.flip_h = true
	#if ray_cast_2d.is_colliding():
		#direction = 1
		#animated_sprite_2d.flip_h = false
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

func patrol():
	animated_sprite_2d.play("chase")
	if ray_cast_2d_2.is_colliding():
		direction = -1
	if ray_cast_2d.is_colliding():
		direction = 1
	velocity.x = direction * SPEED
	animated_sprite_2d.flip_h = (direction == -1)
	print("patrol")

func chase():
	animated_sprite_2d.play("chase")
	direction = 1 if player.global_position.x > global_position.x else -1
	velocity.x = direction * SPEED
	animated_sprite_2d.flip_h = (direction == -1)
	print("chase")
	
func flee():
	animated_sprite_2d.play("chase")
	direction = -1 if player.global_position.x > global_position.x else 1
	velocity.x = direction * (SPEED * 1.2) 
	animated_sprite_2d.flip_h = (direction == -1)
	print("flee")
	if ray_cast_2d.is_colliding() or ray_cast_2d_2.is_colliding():
		despawn()

func attack():
	velocity.x = 0
	animated_sprite_2d.play("attack")
	if(animated_sprite_2d.flip_h == true and animated_sprite_2d.frame == 9 and animated_sprite_2d.animation == "attack"):
		collision_shape_2d1.disabled = true
		collision_shape_2d_2.disabled = false
		
	elif(animated_sprite_2d.flip_h == false and animated_sprite_2d.frame == 9 and animated_sprite_2d.animation == "attack"):
		collision_shape_2d1.disabled = false
		collision_shape_2d_2.disabled = true
		
	
	print("attack")
	await animated_sprite_2d.animation_finished
	collision_shape_2d1.disabled = true
	collision_shape_2d_2.disabled = true
	
	
func despawn():
	is_despawned=true
	velocity = Vector2.ZERO
	visible=false
	collision_shape_2d.call_deferred("set_disabled", true)
	
	await get_tree().create_timer(5.0).timeout
	
	visible=true
	health=MAX_HEALTH
	collision_shape_2d.call_deferred("set_disabled", false)
	is_despawned=false


func _on_hurt_box_damaged(hitbox: Variant) -> void:
	
	health -= hitbox.damage
