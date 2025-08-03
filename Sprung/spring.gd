extends RigidBody2D

@export var max_compress    := 40.0
@export var compress_speed := 60.0
@export var min_force      := 400.0
@export var max_force      := 1200.0

var charge     := 0.0
var start_pos  := Vector2.ZERO
var compressed := false;

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	sleeping   = false
	start_pos  = position
	add_to_group("player"); # For easy collision checks.

func _process(delta):
	pass#if Input.is_action_pressed("compress") and compressed == false:
		#animation_player.play("compress");
	#elif Input.is_action_just_released("compress") and compressed == true:
		#animation_player.play_backwards("compress");

# ——— ROTATION ———
func _integrate_forces(state:PhysicsDirectBodyState2D):
	# Manual turn (steering angle)
	var turn_speed := deg_to_rad(360)
	if Input.is_action_pressed("left"):
		rotation -= turn_speed * state.get_step()
	elif Input.is_action_pressed("right"):
		rotation += turn_speed * state.get_step()
	# Spring launch logic
	if Input.is_action_pressed("compress"):
		charge = min(charge + compress_speed * state.get_step(), max_compress)
		if compressed == false:
			animation_player.play("compress");
		compressed = true;
	if Input.is_action_just_released("compress") and charge > 0.0:
		# Force vertical bias: Flip Y to always go up, clamp X to mild horizontal influence
		var launch_dir = Vector2.UP.rotated(rotation).normalized()
		launch_dir.y = -abs(launch_dir.y)  # Always upward
		var t     = charge / max_compress
		var force = lerp(min_force, max_force, t)
		state.linear_velocity = launch_dir * force
		animation_player.play_backwards("compress");
		charge = 0;
		compressed = false;
