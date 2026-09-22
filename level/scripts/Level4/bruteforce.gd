extends CanvasLayer
@onready var line_edit: LineEdit = $Panel/LineEdit
@onready var file: CanvasLayer = $"../File"

@onready var label: Label = $Panel/Label
@onready var label_2: Label = $Panel/Label2
@onready var timer: Timer = $Panel/Timer

@onready var bruteforce: CanvasLayer = $"."

@export var passw: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bruteforce.visible = false
	line_edit.text_submitted.connect(_on_line_entered)

func _on_line_entered(new_text: String):
	if new_text == passw:
		label_2.text = "Correct password \n Initializing files"
		timer.start()
	else:
		label_2.text = "Incorrect password \n Try again"
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	bruteforce.visible = false
	file.visible = true
	file.done = true
	QuestManager.finish_quest("computer")
