# GameManager.gd (autoloaded)
extends Node;

signal score_updated(new_score); # Tells any HUDs to update.
var score:int = 0;

func add_point():
	score += 1;
	emit_signal("score_updated", score);
