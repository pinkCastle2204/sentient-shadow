
extends Node

# LevelManager.gd
# Add this as an Autoload singleton
# Project > Project Settings > Globals > Autoload

signal level_loading(level_index: int)
signal all_levels_completed

@export var level_paths: Array[String] = [
	"res://scenes/level.tscn",
	"res://scenes/level2.tscn",
	"res://scenes/Level 3/level_3.tscn",
	"res://scenes/Level 4/level_4.tscn",
	"res://scenes/level_5.tscn"
]

var current_level_index: int = 0
@export var fade_duration: float = 0.5

var fade_overlay: ColorRect
var is_transitioning: bool = false


func _ready() -> void:
	_create_fade_overlay()

#black overlay
func _create_fade_overlay() -> void:
	var canvas_layer := CanvasLayer.new()
	canvas_layer.name = "FadeCanvasLayer"
	canvas_layer.layer = 100

	add_child(canvas_layer)

	fade_overlay = ColorRect.new()
	fade_overlay.name = "FadeOverlay"

	fade_overlay.color = Color.BLACK
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

	fade_overlay.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	fade_overlay.modulate.a = 0.0

	canvas_layer.add_child(fade_overlay)



func fade_in() -> void:
	var tween := create_tween()

	tween.tween_property(
		fade_overlay,
		"modulate:a",
		1.0,
		fade_duration
	)

	await tween.finished


func fade_out() -> void:
	var tween := create_tween()

	tween.tween_property(
		fade_overlay,
		"modulate:a",
		0.0,
		fade_duration
	)

	await tween.finished


func load_level(index: int) -> void:
	if is_transitioning:
		return

	if index < 0 or index >= level_paths.size():
		push_error(
			"LevelManager: level index %d is out of range" % index
		)
		return

	is_transitioning = true

	current_level_index = index
	level_loading.emit(current_level_index)

	# 1 fade current level to black
	await fade_in()

	# 2change scene
	var path := level_paths[current_level_index]

	var err := get_tree().change_scene_to_file(path)

	if err != OK:
		push_error(
			"LevelManager: failed to load '%s' (error %d)"
			% [path, err]
		)

		is_transitioning = false
		await fade_out()
		return

	# 3 wait for the new scene to be processed
	await get_tree().process_frame

	#4 fade new level in
	await fade_out()

	is_transitioning = false



#level naviagation
func load_next_level() -> void:
	var next_index := current_level_index + 1

	if next_index >= level_paths.size():
		all_levels_completed.emit()
		return

	load_level(next_index)


func load_previous_level() -> void:
	if current_level_index <= 0:
		return

	load_level(current_level_index - 1)


func reload_current_level() -> void:
	load_level(current_level_index)


func restart_from_first_level() -> void:
	load_level(0)


func get_current_level_number() -> int:
	return current_level_index + 1


func is_last_level() -> bool:
	return current_level_index == level_paths.size() - 1
