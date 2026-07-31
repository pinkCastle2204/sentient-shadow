extends Area2D
class_name HitBox

## Damage this hitbox deals on contact. Set by BringerOfDeath._ready()
## from its `attack_damage` export, so you don't need to set it here too.
@export var damage := 10

## Who owns this hitbox (set to the enemy itself in _ready()). Lets the
## HurtBox on the other end ignore self-hits (see hurt_area.gd).
var attacker: Node


func _ready() -> void:
	# Off by default. attack.gd turns this — and the CollisionShape2D
	# underneath it — on only while the attack animation is swinging.
	monitorable = false
	for c in get_children():
		if c is CollisionShape2D or c is CollisionPolygon2D:
			c.disabled = true
