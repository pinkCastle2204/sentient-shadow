extends Node2D

@onready var player=$Player
@onready var companion=$Companion

func _ready() -> void:
	player.can_move=false
	player.animated_sprite_2d.stop()
	
	await personality.start_dialogue("level_3_ending")
	print("comp:",personality.compassion)
	print("greed:",personality.greed)
	print("vio:",personality.violence)
	print("cour:",personality.courage)
	get_tree().change_scene_to_file("res://scenes/Level 4/level_4.tscn")
	
