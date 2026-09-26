extends CanvasLayer
@onready var door: StaticBody2D = $"../Door"
@onready var player: CharacterBody2D = $"../Player"
@onready var panel: PanelContainer = $Panel


func _ready() -> void:
	panel.visible = false

func _process(delta: float) -> void:
	player.player_inte = panel.visible

func _on_next_level_pressed() -> void:
	LevelManager.load_next_level()
	panel.visible = false
	player.player_inte = false

func _on_optional_boss_pressed() -> void:
	door.visible = false
	door.collision_shape_2d.disabled = true
	panel.visible = false
	player.player_inte = false
