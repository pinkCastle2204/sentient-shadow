extends CharacterBody2D
@export var speed = 50.0
@onready var enemy=$AnimatedSprite2D
@onready var player = $"../player"
@onready var ai=$UtilityBrain
var maxhealth=100.0
var health=100.0

func _physics_process(delta):	
	if Time.get_ticks_msec() > 3000:
		if health>0:
			health-=3*delta
			health=clamp(health,0.0,maxhealth) 
		
	match ai.curr:
		"patrol":
			patrol()
		"flee":
			flee()
		"chase":
			chase()
		"attack":
			attack()
	move_and_slide()


func animate(direction):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			enemy.play("e_walk_right")
		else:
			enemy.play("e_walk_left")
	else:
		if direction.y>0:
			enemy.play("e_walk_down")
		else:
			enemy.play("e_walk_up")

func flee():
	var flee_direction=(global_position-player.global_position).normalized()
	velocity = flee_direction*speed
	animate(flee_direction)
	
func patrol():
	var direction=(player.global_position-global_position).normalized()
	velocity = direction*speed
	animate(direction)

func chase():
	var direction=(player.global_position-global_position).normalized()
	velocity = direction*speed
	animate(direction)

func attack():
	velocity=Vector2.ZERO
	enemy.stop()
