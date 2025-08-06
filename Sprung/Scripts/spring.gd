extends RigidBody2D
# Inspector variables
@export var max_compress    := 40.0;
@export var compress_speed  := 60.0;
@export var min_force       := 400.0;
@export var max_force       := 1200.0;
# Internal state variables
var charge     := 0.0;
var start_pos  := Vector2.ZERO;
var compressed := false;
var air_slow_duration:float = 1.0  # seconds
var air_slow_timer:float = 0.0
var turn_speed := deg_to_rad(360)
# Child nodes.
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

func _physics_process(delta):
	if Input.is_action_pressed("compress"):
		if air_slow_timer > 0:
			Engine.time_scale = 0.3
			turn_speed = deg_to_rad(720);
			air_slow_timer -= delta
	else:
		turn_speed = deg_to_rad(360);
		Engine.time_scale = 1.0
		
# ——— ROTATION ———
func _integrate_forces(state:PhysicsDirectBodyState2D):
	# Manual turn (steering angle)
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
		air_slow_timer = air_slow_duration;
		compressed = false;

func take_damage(damage:int) -> void:
	GameManager.player_take_damage(damage);
