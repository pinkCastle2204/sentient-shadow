extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hitbox: CollisionShape2D = $HitBox/CollisionShape2D
@onready var final_bosshealth: ProgressBar = $"../CanvasLayer2/FinalBosshealth"

@export var talked: bool = false
@export var detectrange: float = 300.0
@export var attackrange: float = 30.0

@onready var target: CharacterBody2D = $"../Player"
const scene1 = preload("res://scenes/endings/hidden-ending.tscn")
const scene2 = preload("res://scenes/endings/hope-ending.tscn")
const scene3 = preload("res://scenes/endings/sacrifice-ending.tscn")
const scene4 = preload("res://scenes/endings/shadow-ending.tscn")

@export var gravity: float = 980.0
@export var health: int
var facing_right: bool = true
var dead: bool
func _ready() -> void:
	health = 100
	dead = false
	
func face_direction(dir_x: float) -> void:
	if dir_x == 0:
		return
	var should_face_right = dir_x > 0
	if should_face_right == facing_right:
		return  # already facing that way, nothing to do

	facing_right = should_face_right
	animated_sprite_2d.flip_h = not facing_right

	# flip the hitbox to the other side
	hitbox.position.x = abs(hitbox.position.x) * (1 if facing_right else -1)
func isNear() -> bool:
	if target == null:
		print("❌ TARGET IS NULL")
		return false

	var distance_x = abs(target.global_position.x - global_position.x)

	#print(
		#"Boss X:", global_position.x,
		#" | Target X:", target.global_position.x,
		#" | Distance:", distance_x,
		#" | Detect Range:", detectrange
	#)

	return distance_x <= detectrange


func isInAttackRange() -> bool:
	if target == null:
		print("target not found")
		return false

	return abs(target.global_position.x - global_position.x) <= attackrange


func _physics_process(delta: float) -> void:
	if dead:
		
		return
	if health <=0:
		dead = true
		final_bosshealth.visible = false
		deadboy()
		return          
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
	final_bosshealth.value = health
	if talked && !dead:
		final_bosshealth.visible = true
	else:
		final_bosshealth.visible = false
	var dir = signf(target.global_position.x - global_position.x)
	face_direction(dir)

func _on_hurt_box_damaged(hitbox: Variant) -> void:
	health -= target.attackDamage
	
	
func deadboy():
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished
	Engine.time_scale = 0.2 

# Wait for 3 real-world seconds (affected by time_scale if default, or use unscaled timer)
	await get_tree().create_timer(1.0, true, false, true).timeout

# Restore normal speed
	Engine.time_scale = 1.0
	queue_free()
	EndingManager.go_to_ending()
	
