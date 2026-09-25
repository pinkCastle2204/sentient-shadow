extends Node2D

@onready var quest1: bool = false
@onready var quest2: bool = false
@onready var monsterDead: bool = false
@onready var level: Node2D = $"."
@onready var bringer_of_death: BringerOfDeath = $BringerOfDeath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@onready var optionality: CanvasLayer = $Optionality
@onready var door: StaticBody2D = $Door

# Called every frame. 'delta' is the elapsed time since the previous frame.
func showop():
	optionality.visible = true
		
