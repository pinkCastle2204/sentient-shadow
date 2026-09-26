extends state

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var enemy: CharacterBody2D = $"../.."

var talked: bool = false


func enter() -> void:
	animated_sprite_2d.play(enemy.ANIM_IDLE)
	enemy.velocity.x = 0.0
	if not Dialogic.signal_event.is_connected(dialogic_signal):
		Dialogic.signal_event.connect(dialogic_signal)


func update(_delta: float) -> void:
	if not enemy.try_detect_player():
		change_state.emit("patrol")
		return

	if Input.is_action_just_pressed("interact") and not talked:
		run_dialogue()


func run_dialogue() -> void:
	talked = true
	Dialogic.start("guard")
	await Dialogic.timeline_ended


func dialogic_signal(arg: String) -> void:
	match arg:
		"NPC3_talk":
			personality.update_personality([15, -5, -10, 5])
			change_state.emit("patrol")
		"NPC3_attack":
			personality.update_personality([-15, 0, 20, 10])
			change_state.emit("attack" if enemy.distance_to_target() <= enemy.attack_range else "chase")
