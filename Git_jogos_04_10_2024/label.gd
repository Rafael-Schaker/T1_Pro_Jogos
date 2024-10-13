extends Label

@onready var score := 0

func updateScore():
	score += 1
	text = "Score: " + str(score)
