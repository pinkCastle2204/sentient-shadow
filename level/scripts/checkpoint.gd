extends Area2D
@onready var checkpoint_manager: Node = $".."
#checkpoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Its working")
		checkpoint_manager.last_location = $respawnPoint.global_position
		
	
