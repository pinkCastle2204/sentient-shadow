extends CanvasLayer
@onready var break_the_system: CanvasLayer = $"."
@onready var timer: Timer = $Panel/Timer
@onready var file: CanvasLayer = $"../File"

@onready var panel: Panel = $Panel
@onready var button: Button = $Panel/Button
@onready var label: Label = $Panel/Label
@export var count:int
@export var req: int
var done:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	count = 0
	randomize()
	break_the_system.visible = false
	req = randi_range(10, 20)  # Returns an int from 1 to 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if count == req && !done:
		label.text = "System Crashed"
		timer.start(4)
		done = true


func _on_button_pressed() -> void:
	count += 1


func _on_timer_timeout() -> void:
	break_the_system.visible = false
	file.visible = true
	file.done = true
	QuestManager.finish_quest("computer")
