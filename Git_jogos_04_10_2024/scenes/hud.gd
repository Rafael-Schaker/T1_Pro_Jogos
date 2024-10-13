extends CanvasLayer

func setScore(score: int):
	$ScoreLabel.text = "Score: " + str(score)
