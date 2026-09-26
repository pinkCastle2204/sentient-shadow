extends Node

enum Ending{

	HOPE,
	SACRIFICE,
	SHADOW,
	HIDDEN
}
var ending_vectors = {

	Ending.HOPE:{

		"compassion":95,
		"greed":5,
		"violence":10,
		"courage":80

	},

	Ending.SACRIFICE:{

		"compassion":55,
		"greed":25,
		"violence":35,
		"courage":95

	},

	Ending.SHADOW:{

		"compassion":5,
		"greed":65,
		"violence":95,
		"courage":90

	},

	Ending.HIDDEN:{

		"compassion":85,
		"greed":15,
		"violence":20,
		"courage":85

	}
}

func get_ending():
	var best_ending = Ending.HOPE
	var smallest_distance = INF

	# Get current personality values
	var compassion = personality.compassion
	var greed = personality.greed
	var violence = personality.violence
	var courage = personality.courage

	for ending in ending_vectors:

		var dc = compassion - ending_vectors[ending]["compassion"]
		var dg = greed - ending_vectors[ending]["greed"]
		var dv = violence - ending_vectors[ending]["violence"]
		var dco = courage - ending_vectors[ending]["courage"]

		var distance = sqrt(
			dc * dc +
			dg * dg +
			dv * dv +
			dco * dco
		)

		if distance < smallest_distance:
			smallest_distance = distance
			best_ending = ending

	return best_ending


func go_to_ending():

	var ending = get_ending()

	print("Final Personality:")
	print("Compassion: ", personality.compassion)
	print("Greed: ", personality.greed)
	print("Violence: ", personality.violence)
	print("Courage: ", personality.courage)

	match ending:

		Ending.HOPE:
			print("ENDING: HOPE")
			get_tree().change_scene_to_file("res://scenes/endings/hope-ending.tscn")

		Ending.SACRIFICE:
			print("ENDING: SACRIFICE")
			get_tree().change_scene_to_file("res://scenes/endings/sacrifice-ending.tscn")

		Ending.SHADOW:
			print("ENDING: SHADOW")
			get_tree().change_scene_to_file("res://scenes/endings/shadow-ending.tscn")

		Ending.HIDDEN:
			print("ENDING: HIDDEN")
			get_tree().change_scene_to_file("res://scenes/endings/hidden-ending.tscn")
