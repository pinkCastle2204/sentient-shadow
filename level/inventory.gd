extends Resource

class_name Inv
signal update
@export var slots: Array[Invslot]

func insert(item: InvItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += 1
		print("Amount is now:", itemslots[0].amount)
	else:	
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
			print("Created new stack")
	update.emit()
	
func removeALL(item: InvItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].item = null
		itemslots[0].amount = 0
		print("The Item is removed now")
	else:	
		
		print("The item was not found")
	update.emit()
