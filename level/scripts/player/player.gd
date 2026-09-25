extends CharacterBody2D

var can_move = true
@onready var timer: Timer = $Timer
@onready var collision_shape_2d_ofplayer: CollisionShape2D = $CollisionShape2D
@onready var checkpoint_manager: Node = $"../checkpointManager"
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var NORMAL_SPEED: float = 250.0
@export var BOOST_SPEED: float = 500.0
@export var NORMAL_JUMP_VELOCITY: float = -450.0
@export var BOOST_JUMP_VELOCITY: float = -700.0

var SPEED = NORMAL_SPEED
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
var boosting = false

func _ready() -> void:
	print(animated_sprite_2d)

func die():
	animated_sprite_2d.play("death")
	dead = true
	attacking = false
	collision_shape_2d.disabled = true
	collision_shape_2d_2.disabled = true
	timer.start()


func _physics_process(delta: float) -> void:
	if not can_move:
		return
	if dead:
		return
	if health <= 0 && !dead:
		die()
		return

	boosting = Input.is_key_pressed(KEY_SHIFT)
	if not attacking:
		SPEED = BOOST_SPEED if boosting else NORMAL_SPEED

	if Input.is_action_just_pressed("attack") and !attacking and is_on_floor():
		animated_sprite_2d.play("attack")
		audio_stream_player.play()
		attacking = true
		SPEED = 000.0
	if Input.is_action_just_pressed("attack") and !attacking and !is_on_floor():
		animated_sprite_2d.play("attack 2")
		audio_stream_player.play()
		attacking = true
		SPEED = 000.0



	# Add the gravity.
	if not is_on_floor():
		if jumpeda == false and not attacking:
			jumpeda = true
			animated_sprite_2d.play("jump")
		elif jumpeda == false:
			jumpeda = true   # still mark airborne, just don't override the anim
		velocity += get_gravity() * delta
	else:
		jumpeda = false


	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor() and !attacking:
		velocity.y = BOOST_JUMP_VELOCITY if boosting else NORMAL_JUMP_VELOCITY


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
	if animated_sprite_2d == null:
		return
	if animated_sprite_2d.animation == "attack":
		if animated_sprite_2d.frame == 3 or animated_sprite_2d.frame == 4 :
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
	attacking = false
	SPEED = NORMAL_SPEED
	jumpeda = false
	velocity = Vector2.ZERO
	collision_shape_2d.disabled = true
	collision_shape_2d_2.disabled = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation in ["attack", "attack 2"]:
		attacking = false
		SPEED = NORMAL_SPEED
		collision_shape_2d.disabled = true
		collision_shape_2d_2.disabled = true
