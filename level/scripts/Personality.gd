extends Node

var compassion = 50
var greed = 50
var violence = 50
var courage = 50

func print_traits():
	print("---------------------")
	print("Compassion :", compassion)
	print("Greed      :", greed)
	print("Honesty    :", violence)
	print("Aggression :", courage)
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
