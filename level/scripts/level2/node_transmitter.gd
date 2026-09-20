extends Node

var player_nearby := false
@onready var label_tx = $Label
@onready var signal_anim = $signal
var quest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quest = QuestManager.get_quest("dead_signal")
	signal_anim.play("signal_off")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_nearby:
		label_tx.show()

		if Input.is_action_just_pressed("interact"):
			interact()
	else:
		label_tx.hide()


func _on_tx_region_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = true
		print("player nearby")


func _on_tx_region_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = false
		print("player not nearby")
func interact():
	if quest == null:
		print("Dead Signal quest not found!")
		return

	if !quest["started"]:
		print("You haven't started Dead Signal yet.")
		return

	if quest["completed"]:
		print("Transmitter already repaired.")
		return

	print("Transmitter repaired!")
	print("Network restored!")
	signal_anim.play("signal_on")

	QuestManager.add_progress("dead_signal")
