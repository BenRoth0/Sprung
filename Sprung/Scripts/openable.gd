class_name Openable;
extends Node2D;
# So different looks can be applied. Should have the open, closed, and broken animations.
@export var sprite_frames: SpriteFrames
@export var initial_state:State;
# Internal state
enum State { # each state animation needs to be named exactly the same as the state.
	open, 
	closed,
	broken
}
var cur_state:State;
var player_in_area:bool=false;
# Child nodes.
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	animated_sprite.sprite_frames = sprite_frames;
	Transition_To(initial_state);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match(cur_state):
		State.open:
			return;
		State.closed:
			if player_in_area and Input.is_action_just_released("open"):
				GameManager.add_point();
				Transition_To(State.open);
		State.broken:
			return;
	
func Transition_To(new_state:State):
	if new_state == cur_state:
		return; # If it ain't broke, don't fix it.
	cur_state = new_state;
	#play animation if it exists
	if not State.keys()[cur_state] in animated_sprite.sprite_frames.get_animation_names():
		return;
	animated_sprite.play(State.keys()[cur_state]);

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = true;

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = false;	
