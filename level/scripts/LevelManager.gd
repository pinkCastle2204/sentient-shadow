extends Node


# LevelManager.gd
# Add this as an Autoload singleton (Project > Project Settings > Autoload)
# so it persists across scene changes and can be called from anywhere as:
#   LevelManager.load_next_level()

signal level_loading(level_index: int)
signal all_levels_completed

# Set these in the Inspector once this is added as an Autoload,
# or just edit the paths below directly.
@export var level_paths: Array[String] = [
	"res://scenes/level.tscn",
	"res://scenes/level2.tscn",
	"res://scenes/Level 3/level_3.tscn",
	"res://scenes/Level 4/level_4.tscn",
	"res://scenes/level_5.tscn"
]

var current_level_index: int = 0 # 0-based internally; "level 1" = index 0


func load_level(index: int) -> void:
	if index < 0 or index >= level_paths.size():
		push_error("LevelManager: level index %d is out of range" % index)
		return

	current_level_index = index
	level_loading.emit(current_level_index)

	var path := level_paths[current_level_index]
	var err := get_tree().change_scene_to_file(path)
	if err != OK:
		push_error("LevelManager: failed to load '%s' (error %d)" % [path, err])


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
