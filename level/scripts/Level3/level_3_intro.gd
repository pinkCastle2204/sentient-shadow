extends Node2D

@onready var player=$Player
@onready var companion=$Companion

func _ready() -> void:
	player.can_move=false
	player.animated_sprite_2d.stop()
	Dialogic.start("level_3_intro")
	await Dialogic.timeline_ended
	get_tree().change_scene_to_file("res://scenes/Level 3/level_3.tscn")
	
	
