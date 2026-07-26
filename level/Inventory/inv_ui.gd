extends Control

@onready var inv : Inv = preload("res://Inventory/player_inv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()


func update_slots():
	print("Updateslot")
	for i in range(min(inv.slots.size(),slots.size())):
		slots[i].update(inv.slots[i])
		
var isOpen = false
func _ready() -> void:
	print("read")
	inv.update.connect(update_slots)
	update_slots()
	close()

func _process(delta):
	if Input.is_action_just_pressed("i_button"):
		print("I is pressed")
		if isOpen:
			close()
		else:
			open()

func open():
	self.visible = true
	isOpen = true
func close():
	self.visible = false
	isOpen = false
