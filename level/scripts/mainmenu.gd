extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1_intro.tscn")
	


func _on_controls_pressed() -> void:
	canvas_layer.visible = true


func _on_button_pressed() -> void:
	canvas_layer.visible = false
