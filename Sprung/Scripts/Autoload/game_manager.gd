# GameManager.gd (autoloaded)
extends Node;

signal score_updated(new_score); # Tells any HUDs to update.
signal player_health_updated(new_health); # Tells any HUDs to update.
var player_max_health:float = 100.0;
var player_health:float = player_max_health;
var score:int = 0;

func add_point():
	score += 1;
	emit_signal("score_updated", score);

func player_take_damage(damage:float):
	if player_health == 0:
		return;
	player_health -= damage;
	emit_signal("player_health_updated", player_health);
