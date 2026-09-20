extends Node

var player_nearby := false
var interaction_locked := false
var quest
var selected_route := ""
@onready var label_doorlockedmsg = $"../Player/Camera2D/Door_Locked"
@onready var label_doolockinfo = $"../Player/Camera2D/Door_info"
@onready var route_choice = $"../Player/Camera2D/Door_info/route_choice"
@onready var door = $MainframeDoor
@onready var hackterminal = $"../Player/Camera2D/hack-terminal"
@onready var forceentry = $"../Player/Camera2D/ForceEntry"

func open_door():
	print("Hospital door opening!")
	var tween = create_tween()
	tween.tween_property(
		door,
		"position:y",
		door.position.y - 100,
		1.0
	)
	await tween.finished
	QuestManager.finish_quest("dead_signal")
	print("Dead Signal stealth route completed!")

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

		return

	if selected_route == "stealth":
		if quest["completed"]:
			print("Network restored. Door terminal available.")

			label_doolockinfo.hide()
			hackterminal.show()
		else:
			print("Network is still offline.")

	elif selected_route == "force":
		print("Force entry route selected.")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = false


func _on_restore_pressed() -> void:
	print("Starting tranasmitter repair ....")
	selected_route = "stealth"
	route_choice.hide()
	label_doolockinfo.text="Find the transmitter and restore the signal"


func _on_hackterminal_hack_successful() -> void:
	print("Door hack successful!")
	hackterminal.hide()
	open_door()
	label_doolockinfo.hide()
	label_doorlockedmsg.hide()
	


func _on_force_pressed() -> void:
		print("Force entry selected!")
		selected_route = "force"
		route_choice.hide()
		label_doolockinfo.show()
		label_doolockinfo.text = "FORCE ENTRY\nBypass the hospital door."
		forceentry.show()


func _on_force_entry_force_entry_success() -> void:
	print("Force entry successful!")
	forceentry.hide()
	label_doolockinfo.hide()
	label_doorlockedmsg.hide()
	open_door()
