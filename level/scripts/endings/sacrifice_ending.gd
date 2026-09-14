extends Node2D
@onready var player=$Player
@onready var companion=$Companion
@onready var family=$FamilyMember/AnimatedSprite2D
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var machine_audio = $MachineAudio

func _ready():
	player.animated_sprite_2d.flip_h = true
	player.can_move=false
	player.animated_sprite_2d.stop()
	family.stop()
	companion.visible=false
	Dialogic.start("sacrifice-ending")
	await Dialogic.timeline_ended
	await fade_to_black()
	await sacrifice_sequence()
	await sacrifice_aftermath()
	await Dialogic.timeline_ended
	await fade_to_black()

	
func fade_to_black() -> void:
	var tween = create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 1), 1.5)
	await tween.finished
	
func sacrifice_sequence() -> void:
	await get_tree().create_timer(1.5).timeout
	machine_audio.play()
	Dialogic.start("sacrifice-process")
	await Dialogic.timeline_ended
	machine_audio.stop()
	await get_tree().create_timer(2.0).timeout
	family.queue_free()
	
func sacrifice_aftermath() ->void:
	var tween = create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 0), 1.5)
	await tween.finished
	companion.visible=true
	Dialogic.start("sacrifice-aftermath")
