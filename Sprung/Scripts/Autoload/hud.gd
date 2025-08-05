extends CanvasLayer
# UI elements
@onready var score: Label = %Score
@onready var health_bar: ProgressBar = $HealthBar

func _ready():
	# Score counter
	GameManager.score_updated.connect(update_score);
	# Health bar
	health_bar.min_value = 0.0
	health_bar.max_value = GameManager.player_max_health;
	health_bar.value = GameManager.player_health;
	GameManager.player_health_updated.connect(update_health);

func update_score(new_score):
	score.text = "Score: " + str(new_score);
	
func update_health(new_health):
	health_bar.value = new_health;
