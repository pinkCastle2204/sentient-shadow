extends Node
# checkpoint manager
var last_location

@onready var player: CharacterBody2D = $"../Player"

func _ready() -> void:
	
	last_location = player.global_position
	
