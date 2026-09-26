extends Node

var compassion = 50
var greed = 50
var violence = 50
var courage = 50

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
		"greed": 90,
		"violence": 60,
		"courage": 30
	},

	"Empathy": {
		"compassion": 90,
		"greed": 10,
		"violence": 10,
		"courage": 60
	},

	"Aggressive": {
		"compassion": 15,
		"greed": 50,
		"violence": 95,
		"courage": 85
	},

	"Brave": {
		"compassion": 55,
		"greed": 15,
		"violence": 40,
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
	compassion = clamp(compassion + arr[0], 1, 100)
	greed = clamp(greed + arr[1], 1, 100)
	violence = clamp(violence + arr[2], 1, 100)
	courage = clamp(courage + arr[3], 1, 100)
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
	compassion = clamp(Dialogic.VAR.compassion, 1, 100)
	greed = clamp(Dialogic.VAR.greed, 1, 100)
	violence = clamp(Dialogic.VAR.violence, 1, 100)
	courage = clamp(Dialogic.VAR.courage, 1, 100)
	
	classify_personality()
	
func start_dialogue(timeline_name): 
	sync_to_dialogic() 
	Dialogic.start(timeline_name) 
	await Dialogic.timeline_ended 
	update_from_dialogic()
