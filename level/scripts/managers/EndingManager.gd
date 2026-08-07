extends Node
enum Ending{

	HOPE,
	SACRIFICE,
	SHADOW,
	TRUE
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

	Ending.TRUE:{

		"compassion":85,
		"greed":15,
		"violence":20,
		"courage":85

	}

}

func calculate_distance(player, ending):
	var dc = player["compassion"] - ending["compassion"]
	var dg = player["greed"] - ending["greed"]
	var dv = player["violence"] - ending["violence"]
	var dco = player["courage"] - ending["courage"]

	return sqrt(
		dc * dc +
		dg * dg +
		dv * dv +
		dco * dco
	)
	
func determine_ending():
	var player = personality.get_vector()
	var best_ending = ""
	var best_distance = INF

	for ending_name in ending_vectors:

		var distance = calculate_distance(
			player,
			ending_vectors[ending_name]
		)

		print(ending_name, " distance = ", distance)

		if distance < best_distance:

			best_distance = distance
			best_ending = ending_name

	print("FINAL ENDING: ", best_ending)

	return best_ending
	
func play_ending():
	var ending = determine_ending()
	match ending:
		"Hope":
			pass
		"Sacrifice":
			pass
		"Shadow":
			pass
		"True":
			pass
	#this will be updated once we create the endings
	
