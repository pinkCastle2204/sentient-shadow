extends CanvasLayer

@onready var file: CanvasLayer = $"."
var done: bool = false
var watch:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	file.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if done && Input.is_action_just_pressed("interact"):
		file.visible = false
		watch = true
	if watch:
		file.visible = false
		
