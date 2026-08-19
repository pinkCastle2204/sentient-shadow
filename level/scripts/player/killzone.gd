extends Area2D

@onready var checkpoint_manager: Node = $"../checkpointManager"
@onready var player: CharacterBody2D = $"../Player"

var is_killing := false


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	if is_killing:
		return
	
	killplayer()


func killplayer() -> void:
	is_killing = true
	
	player.dead = true
	player.animated_sprite_2d.play("death")
	
	await get_tree().create_timer(1.0).timeout
	
	player.global_position = checkpoint_manager.last_location
	
	player.dead = false
	is_killing = false
