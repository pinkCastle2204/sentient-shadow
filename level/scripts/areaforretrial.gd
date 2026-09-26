extends Area2D
@onready var optionality: CanvasLayer = $"../Optionality"
@onready var level: Node2D = $".."

@onready var player: CharacterBody2D = $"../Player"
@onready var areaforretrial: Area2D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	optionality.panel.visible = false
	player.player_inte = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player"):
		optionality.panel.visible = true
		print("what to do ")
