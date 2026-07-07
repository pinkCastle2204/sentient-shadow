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

@onready var enemy=$".."
@onready var player: CharacterBody2D = $"../../player"


@onready var label: Label = $"../Panel/Label"




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

	chase_score=health_ratio*(1.0 - distance_normalised)

	attack_score=0.0
	if distance<=attack_range:
		attack_score=health_ratio

	flee_score=(1.0-health_ratio)*(1.0-distance_normalised)
	
	var highest = -1
	var current_action = Action.Patrol
	
	if chase_score>highest:
		highest=chase_score
		current_action=Action.Chase
		
	if attack_score>highest:
		highest=attack_score
		current_action=Action.Attack
		
	if patrol_score>highest:
		highest=patrol_score
		current_action=Action.Patrol
	
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
			
	if enemy.health != 0:
		#label.text="Health: %.2f\n" %enemy.health
		#label.text+=" Distance: %.2f\n" %distance
		#label.text+=" Patrol Score: %.2f\n" %patrol_score
		#label.text+=" Chase Score: %.2f\n" %chase_score
		#label.text+=" Attack Score: %.2f\n" %attack_score
		#label.text+=" Flee Score: %.2f\n" %flee_score
		label.text ="ACTIVE:" + curr.to_upper() 
	
	#print("Distance:",distance)
	#print("Patrol score:",patrol_score)
	#print("Chase score:",chase_score)
	#print("Attack score:",attack_score)
	#print("Flee score:",flee_score)
	#print("Action:",curr)	
	#print("Health:",enemy.health)
	#print("\n")
	
