extends CharacterBody2D
@onready var panel_container: PanelContainer = $PanelContainer

@onready var label: Label = $PanelContainer/VBoxContainer/Label
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var button: Button = $PanelContainer/VBoxContainer/HBoxContainer/Button
@onready var button_2: Button = $PanelContainer/VBoxContainer/HBoxContainer/Button2
@onready var button_3: Button = $PanelContainer/VBoxContainer/HBoxContainer/Button3
@onready var h_box_container: HBoxContainer = $PanelContainer/VBoxContainer/HBoxContainer
@onready var monster: CharacterBody2D = $"../Monster"


func _ready():
	button.pressed.connect(_on_normal_pressed)
	button_2.pressed.connect(_on_brave_pressed)
	button_3.pressed.connect(_on_stressed_pressed)

func _process(delta: float) -> void:
	panel_container.visible = ray_cast_2d.is_colliding()
		
func _on_normal_pressed():
	monster.fleeMul = 1.0
	monster.attackMul = 1.0
	h_box_container.queue_free()
	label.text = "Oh, so you are feeling normal.\nNo worries, go there, there is a slime monster."

func _on_brave_pressed():
	monster.fleeMul = 0.0
	monster.attackMul = 1.0
	h_box_container.queue_free()
	label.text = "Oh, so you are feeling brave.\nThe monster will be more aggressive. Be careful."

func _on_stressed_pressed():
	monster.fleeMul = 1.0
	monster.attackMul = 0.4
	h_box_container.queue_free()
	label.text = "Oh, so you are feeling stressed.\nNo worries, the slime monster will flee away."
