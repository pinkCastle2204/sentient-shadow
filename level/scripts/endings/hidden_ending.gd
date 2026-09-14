extends Node2D
@onready var player=$Player
@onready var family=$FamilyMember/AnimatedSprite2D
@onready var companion=$Companion
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

func _ready():
	player.animated_sprite_2d.flip_h = true
	player.can_move=false
	player.animated_sprite_2d.stop()
	family.stop()
	
	Dialogic.start("hidden-ending")
	await Dialogic.timeline_ended
	await fade_to_black(0.75)
	player.global_position=Vector2(1392,1034)
	companion.global_position=Vector2(1458,1006)
	family.global_position=Vector2(1303,979)
	await fade_from_black(0.75)
	Dialogic.start("hidden-aftermath")
	await Dialogic.timeline_ended
	fade_to_black(1.5)
	
func fade_to_black(time) -> void:
	var tween = create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 1), time)
	await tween.finished

func fade_from_black(time)->void:
	var tween = create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 0), time)
	await tween.finished
