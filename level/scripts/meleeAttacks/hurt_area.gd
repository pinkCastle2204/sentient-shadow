extends Area2D
class_name HurtBox

signal damaged(hitbox)

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area is HitBox:
		if area.attacker == get_parent():
			return  
		damaged.emit(area)
