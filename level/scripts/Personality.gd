extends Node

var compassion = 10
var greed = 95
var violence = 35
var courage = 45

func print_traits():
	print("---------------------")
	print("Compassion :", compassion)
	print("Greed      :", greed)
	print("Violence    :", violence)
	print("Courage :", courage)
	print("---------------------")

var personalities = {
	"Selfish": {
		"compassion": 10,
		"greed": 95,
		"violence": 35,
		"courage": 45
	},

	"Empathy": {
		"compassion": 95,
		"greed": 10,
		"violence": 15,
		"courage": 70
	},

	"Aggressive": {
		"compassion": 15,
		"greed": 40,
		"violence": 95,
		"courage": 80
	},

	"Brave": {
		"compassion": 60,
		"greed": 20,
		"violence": 45,
		"courage": 95
	}
}

var best_name = ""
func distance_to(personality):

	var dc = compassion - personality["compassion"]
	var dg = greed - personality["greed"]
	var dv = violence - personality["violence"]
	var dco = courage - personality["courage"]

	return sqrt(
		dc * dc +
		dg * dg +
		dv * dv +
		dco * dco
	)
func update_personality(arr: Array):
	if(arr.size() != personalities.size()):
		print("The size to update personality is wrong")
		return
	compassion += arr[0]
	greed += arr[1]
	violence += arr[2]
	courage += arr[3]
	classify_personality()
	print_traits()
func classify_personality():

	var best_distance = INF

	for name in personalities.keys():

		var d = distance_to(personalities[name])

		#print(name, " -> ", d)

		if d < best_distance:
			best_distance = d
			best_name = name

	#print("---------------------")
	#print("Current Personality:", best_name)
	#print("---------------------")

	return best_name
	
func sync_to_dialogic(): 
	Dialogic.VAR.compassion = compassion 
	Dialogic.VAR.greed = greed 
	Dialogic.VAR.violence = violence 
	Dialogic.VAR.courage = courage 
	
func update_from_dialogic(): 
	compassion = clamp(Dialogic.VAR.compassion, 0, 100)
	greed = clamp(Dialogic.VAR.greed, 0, 100)
	violence = clamp(Dialogic.VAR.violence, 0, 100)
	courage = clamp(Dialogic.VAR.courage, 0, 100)
	
	classify_personality()
	
func start_dialogue(timeline_name): 
	sync_to_dialogic() 
	Dialogic.start(timeline_name) 
	await Dialogic.timeline_ended 
	update_from_dialogic()
