extends Node2D
@onready var player=$Player
@onready var family=$FamilyMember/AnimatedSprite2D
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

func _ready():
	player.animated_sprite_2d.flip_h = true
	player.can_move=false
	player.animated_sprite_2d.stop()
	family.stop()
	Dialogic.start("shadow-ending")
	await Dialogic.timeline_ended
	fade_to_black()
	
func fade_to_black() -> void:
	var tween = create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 1), 1.5)
	await tween.finished
