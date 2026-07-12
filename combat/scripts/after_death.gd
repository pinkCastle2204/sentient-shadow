extends Control
@onready var button: Button = $Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
