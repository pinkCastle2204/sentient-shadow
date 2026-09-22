extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hitbox: CollisionShape2D = $HitBox/CollisionShape2D
@onready var final_bosshealth: ProgressBar = $"../CanvasLayer2/FinalBosshealth"

@export var talked: bool = false
@export var detectrange: float = 300.0
@export var attackrange: float = 30.0
@export var attack_damage: int = 15  # base damage, before personality scaling

@onready var target: CharacterBody2D = $"../Player"
const scene1 = preload("res://scenes/endings/hidden-ending.tscn")
const scene2 = preload("res://scenes/endings/hope-ending.tscn")
const scene3 = preload("res://scenes/endings/sacrifice-ending.tscn")
const scene4 = preload("res://scenes/endings/shadow-ending.tscn")

@export var gravity: float = 980.0
@export var health: int
var facing_right: bool = true
var dead: bool

# --- Personality-driven combat scaling (reacts to the PLAYER's trait vector) ---
var aggro_multiplier: float = 1.0
var damage_multiplier: float = 1.0
var effective_attack_damage: int = 15


func _ready() -> void:
	health = 100
	dead = false
	refresh_personality_scaling()


func refresh_personality_scaling() -> void:
	var violence: float = personality.violence
	var compassion: float = personality.compassion

	aggro_multiplier = 1.0 + (violence - 50.0) / 100.0        # ~0.5x to 1.5x
	damage_multiplier = 1.0 + (violence - 50.0) / 150.0 - (compassion - 50.0) / 200.0

	effective_attack_damage = int(attack_damage * damage_multiplier)


func get_effective_detect_range() -> float:
	return detectrange * aggro_multiplier


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
	return distance_x <= get_effective_detect_range()


func isInAttackRange() -> bool:
	if target == null:
		print("target not found")
		return false

	return abs(target.global_position.x - global_position.x) <= attackrange


func _physics_process(delta: float) -> void:
	if dead:
		return
	if health <= 0:
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


func deal_damage_to_player() -> void:
	# Call this from your attack-hit logic (wherever the boss currently
	# applies damage to the player) instead of a hardcoded value.
	target.health -= effective_attack_damage


func deadboy():
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished
	Engine.time_scale = 0.2

	await get_tree().create_timer(1.0, true, false, true).timeout

	Engine.time_scale = 1.0
	EndingManager.go_to_ending()
	queue_free()
