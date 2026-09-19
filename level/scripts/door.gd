extends Node

var player_nearby := false
var interaction_locked := false
var quest
@onready var label_doorlockedmsg = $"../Player/Camera2D/Door_Locked"
@onready var label_doolockinfo = $"../Player/Camera2D/Door_info"
@onready var route_choice = $"../Player/Camera2D/Door_info/route_choice"


func _ready() -> void:
	quest = QuestManager.get_quest("dead_signal")

	if quest == null:
		print("ERROR: dead_signal quest not found!")
	else:
		print("dead_signal quest found!")


func _process(_delta: float) -> void:
	if !player_nearby:
		label_doorlockedmsg.hide()
		return

	if quest == null:
		print("Quest doesn't exist!")
		return

	if Input.is_action_just_pressed("interact"):
		interact()

	if !quest["completed"]:
		label_doorlockedmsg.show()
	else:
		label_doorlockedmsg.hide()


func interact():
	if quest == null:
		print("Quest doesn't exist!")
		return

	if !quest["started"]:
		QuestManager.start_quest("dead_signal")
		print("Dead Signal quest started!")
		label_doorlockedmsg.hide()
		label_doolockinfo.show()
		route_choice.show()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = false


func _on_restore_pressed() -> void:
	print("Starting tranasmitter repair ....")
	route_choice.hide()
	label_doolockinfo.text="Find the transmitter and restore the signal"
