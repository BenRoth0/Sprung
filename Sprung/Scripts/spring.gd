extends RigidBody2D
# Inspector variables
@export var max_compress    := 40.0;
@export var compress_speed  := 60.0;
@export var min_force       := 400.0;
@export var max_force       := 1200.0;
# Internal state variables
var is_charging = false
var charge_time = 0.0 # How long charge has been held
var max_charge = 1.0 # One second
var launch_strength = 600.0 # How poweful jumps are. Can be upgraded later.
var aim_angle = 0.0 # The launch angle that the player has selected with the arrow keys.
var launch_vector = Vector2.ZERO 
var launch_ready = false # A flag used to tell _integrate_forces to perform the jump.

# Child nodes.
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var aim_arc: Line2D = $AimArc

func _ready():
	sleeping   = false
	add_to_group("player"); # For easy collision checks.

func _input(event):
	if event.is_action_pressed("compress"):
		is_charging = true;
		charge_time = 0.0;

	if event.is_action_released("compress") and is_charging:
		is_charging = false;
		launch_ready = true;

# ——— ROTATION ———
func _physics_process(delta):
	if is_charging:
		charge_time = min(charge_time + delta, max_charge);
		if Input.is_action_pressed("ui_left"):
			aim_angle -= deg_to_rad(90) * delta;
		elif Input.is_action_pressed("ui_right"):
			aim_angle += deg_to_rad(90) * delta;
		aim_angle = clamp(aim_angle, deg_to_rad(-90), deg_to_rad(90));
		var strength = charge_time / max_charge;
		var direction =  Vector2.UP.rotated(aim_angle).normalized();
		launch_vector = direction * launch_strength * strength;
		aim_arc.update_arc(global_position,launch_vector);
	else:
		aim_arc.clear_points();
	if is_resting() and abs(rotation) > deg_to_rad(10):
		rotation = 0.0
		angular_velocity = 0.0

func _integrate_forces(state):
	if launch_ready:
		state.linear_velocity = launch_vector;
		aim_angle = 0;
		launch_ready = false;

func is_resting():
	return linear_velocity.length() < 10.0 and abs(angular_velocity) < 1.0;

func take_damage(damage:int) -> void:
	GameManager.player_take_damage(damage);
