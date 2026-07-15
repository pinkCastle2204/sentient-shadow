extends Node
enum Action{Patrol, Attack, Chase, Flee}
var patrol_score=0.0
var attack_score=0.0
var chase_score=0.0
var flee_score=0.0
var curr="patrol"

var timer = 0.0

@export var attack_range=50.0
@export var detect_range=350.0

@export var aggression=1.0
@export var cowardice=1.0
@export var enemy_name="name"

@onready var enemy=$".."
@onready var player=$"../../player"

@onready var label =$"../Panel/Label"

func _physics_process(delta):
	timer+=delta
	if timer>=0.5:
		timer=0
		think()

func think():
	var distance=enemy.global_position.distance_to(player.global_position)
	var health_ratio = enemy.health/enemy.maxhealth
	
	var distance_normalised = clamp(distance/detect_range,0,1)
	
	patrol_score=distance_normalised

	chase_score=health_ratio*(1.0 - distance_normalised)*aggression

	attack_score=0.0
	if distance<=attack_range:
		attack_score=health_ratio*aggression*1.5

	flee_score=(1.0-health_ratio)*(1.0-distance_normalised)*cowardice
	
	if curr=="flee":
		if distance_normalised<0.9:
			flee_score+=1.5
		if distance_normalised>=0.9:
			enemy.queue_free()
	
	var highest = patrol_score
	var current_action = Action.Patrol
	
	if chase_score>highest:
		highest=chase_score
		current_action=Action.Chase
		
	if attack_score>highest:
		highest=attack_score
		current_action=Action.Attack
	
	if flee_score>highest:
		highest=flee_score
		current_action=Action.Flee
		
	match current_action:
		Action.Patrol:
			curr="patrol"
		Action.Chase:
			curr="chase"
		Action.Attack:
			curr="attack"
		Action.Flee:
			curr="flee"
			
	
	label.text="Health: %.2f\n" %enemy.health
	label.text+="Distance: %.2f\n" %distance
	label.text+="Name: " + enemy_name +"\n"
	label.text+="Patrol Score: %.2f\n" %patrol_score
	label.text+="Chase Score: %.2f\n" %chase_score
	label.text+="Attack Score: %.2f\n" %attack_score
	label.text+="Flee Score: %.2f\n" %flee_score
	label.text+="ACTIVE: " + curr.to_upper() 
	
	
	
