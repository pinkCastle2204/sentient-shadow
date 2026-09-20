extends Control
signal force_entry_success
@onready var timingbar = $Panel/MarginContainer/VBoxContainer/timingbar
@onready var lockstatus = $"Panel/MarginContainer/VBoxContainer/lock status"
var direction := 1.0
var speed := 60.0

var safe_min := 40.0
var safe_max := 60.0
var bar_running:= true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		randomize_safe_zone()



func _process(delta: float) -> void:
	if !bar_running:
		return

	timingbar.value += direction * speed * delta

	if timingbar.value >= timingbar.max_value:
		timingbar.value = timingbar.max_value
		direction = -1.0

	elif timingbar.value <= timingbar.min_value:
		timingbar.value = timingbar.min_value
		direction = 1.0

func _on_bypassbutton_pressed() -> void:
	var current_value = timingbar.value

	if current_value >= safe_min and current_value <= safe_max:
		bar_running = false
		print("BYPASS SUCCESSFUL!")
		lockstatus.text = "ACCESS GRANTED"
		force_entry_success.emit()
	else:
		print("BYPASS FAILED!")
		lockstatus.text = "ACCESS DENIED-TRY AGAIN"
		
func randomize_safe_zone() -> void:
	safe_min = randf_range(10.0, 70.0)
	safe_max = safe_min + 20.0
	print("DEBUG SAFE ZONE: ", safe_min, " - ", safe_max)
