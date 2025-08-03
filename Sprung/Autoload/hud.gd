extends CanvasLayer

@onready var score: Label = %Score

func _ready():
	GameManager.score_updated.connect(update_score);

func update_score(new_score):
	score.text = "Score: " + str(new_score);
