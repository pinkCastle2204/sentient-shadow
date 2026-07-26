extends Panel


@onready var item_display: Sprite2D = $CenterContainer/Panel/item_display
@onready var label: Label = $CenterContainer/Panel/Label


func update(slot: Invslot):
	if !slot.item:
		item_display.visible = false
		label.visible = false
	else:
		item_display.visible = true
		item_display.texture = slot.item.texture
		label.visible = true
		label.text = str(slot.amount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
