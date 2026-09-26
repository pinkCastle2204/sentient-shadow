extends Area2D
@onready var checkpoint_manager: Node = $".."
#checkpoint

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Its working")
		checkpoint_manager.last_location = $respawnPoint.global_position
		
