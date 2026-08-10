extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("Something entered:", body.name)

	if body.is_in_group("Player"):
		print("PLAYER DETECTED!")
		body.die()
