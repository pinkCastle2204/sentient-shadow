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
