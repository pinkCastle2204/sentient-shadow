extends Node
class_name CheckpointManager
# checkpoint manager
var last_location
@export var monsters : Array[CharacterBody2D]
@onready var player: CharacterBody2D = $"../Player"

func _ready() -> void:
	last_location = player.global_position


func _process(delta: float) -> void:
	for i in range(monsters.size() - 1, -1, -1):
		if monsters[i] == null or not is_instance_valid(monsters[i]):
			monsters.remove_at(i)


func respawn_monsters() -> void:
	for monster in monsters:
		if is_instance_valid(monster) and "health" in monster:
			if "max_health" in monster:
				monster.health = monster.max_health
			else:
				monster.health = 100 # fallback if no max_health defined
