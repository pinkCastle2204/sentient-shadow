extends Path2D
@export var loop =true
@export var speed = 2.0
@export var speed_scale = 1.0

@onready var path = $PathFollow2D1
@onready var animation = $AnimatableBody2D/CollisionShape2D/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not loop:
		animation.play("move_platform1")
		animation.speed_scale = speed_scale
		set_process(false)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path.progress+=speed
	
