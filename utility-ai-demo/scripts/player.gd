extends CharacterBody2D
@export var speed =250.0
@onready var sprite = $AnimatedSprite2D
var last_dir="down"
@export var player_health = 100
@onready var label2: Label = $Panel2/Label
@onready var label3: Label = $Camera2D/PanelContainer/Panel/Label
@onready var panel_container: PanelContainer = $Camera2D/PanelContainer





func _physics_process(_delta: float):
	var direction = Input.get_vector("walk_left","walk_right","walk_up","walk_down")
	velocity=direction*speed
	animate(direction)
	move_and_slide()
	label2.text = "Health: " + str(player_health)
	if player_health <= 0:
		sprite.visible = false
		label2.visible = false
		panel_container.visible = true
		label3.text = "You died "
		
func animate(direction):
	if direction==Vector2.ZERO:
		sprite.play("idle_"+last_dir)
		return
	else:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				sprite.play("walk_right")
				last_dir="right"
			else:
				sprite.play("walk_left")
				last_dir="left"
		else:
			if direction.y > 0:
				sprite.play("walk_down")
				last_dir="down"
			else:
				sprite.play("walk_up")
				last_dir="up"
