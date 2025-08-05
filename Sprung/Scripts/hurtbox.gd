class_name Hurtbox
extends Area2D
# Inspector variables
@export var is_active:bool = false;
@export var invulnerability_window:float; # Number of seconds until you can be hurt again.
# Internal state variables.
var hit_delay_timer := invulnerability_window;

func _init() -> void:
	collision_layer = 0;
	collision_mask = 2;

func _physics_process(delta: float) -> void:
	# Toggle is_active based on whether or not we're in the invulnerability window.
	if hit_delay_timer > 0:
		hit_delay_timer -= delta;
		return; # Haha! I'm invincible!
	# Check for hit and deal damage if they can take it.
	for area in get_overlapping_areas():
		if area is Hitbox and area.is_active:
			if owner.has_method("take_damage") && hit_delay_timer <= 0:
				owner.take_damage(area.damage);
				hit_delay_timer = invulnerability_window;
