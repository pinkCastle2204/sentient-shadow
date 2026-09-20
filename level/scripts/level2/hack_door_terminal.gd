extends Control
signal hack_successful

var current_node := 0
@onready var status = $Panel/MarginContainer/VBoxContainer/Status
@onready var node_a = $Panel/MarginContainer/VBoxContainer/Nodes/NodeA
@onready var node_b = $Panel/MarginContainer/VBoxContainer/Nodes/NodeB
@onready var node_c = $Panel/MarginContainer/VBoxContainer/Nodes/NodeC
@onready var node_d = $Panel/MarginContainer/VBoxContainer/Nodes/NodeD
func _ready() -> void:
	status.text = "SELECT NODE A"


func _on_node_a_pressed() -> void:
	if current_node == 0:
		current_node = 1
		status.text = "NODE A CONNECTED\nSELECT NODE B"
	else:
		wrong_node()


func _on_node_b_pressed() -> void:
	if current_node == 1:
		current_node = 2
		status.text = "NODE B CONNECTED\nSELECT NODE C"
	else:
		wrong_node()


func _on_node_c_pressed() -> void:
	if current_node == 2:
		current_node = 3
		status.text = "NODE C CONNECTED\nSELECT NODE D"
	else:
		wrong_node()


func _on_node_d_pressed() -> void:
	if current_node == 3:
		current_node = 4
		status.text = "NODE D CONNECTED\nACCESS GRANTED"
		print("HACK SUCCESSFUL!")
		hack_successful.emit()
	else:
		wrong_node()


func wrong_node() -> void:
	status.text = "ACCESS DENIED\nWRONG NODE"
	print("Wrong node!")



func _process(delta: float) -> void:
	pass


func _on_reset_pressed() -> void:
	current_node = 0
	status.text = "CONNECTION RESET\nSELECT NODE A"
	print("Hack sequence reset.")
