extends Node2D

# Inspector variables.
@export var interval:float = 3.0; # 3 seconds between extensions.
@export var initial_state = State.off;
@export var sprite_frames: SpriteFrames; # So different looks can be applied. Should have the on and off animations.
# Child nodes.
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D;
@onready var hitbox: Hitbox = $Hitbox

# Internal state variables.
enum State {
	on,
	off
}
var cur_state:State = initial_state;
var pause_timer = interval;

func _ready() -> void:
	animated_sprite.sprite_frames = sprite_frames;
	Transition_To(initial_state);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match(cur_state):
		State.off:
			hitbox.is_active = false;
			if pause_timer <= 0.0:
				Transition_To(State.on);
			pause_timer -= delta;
		State.on:
			hitbox.is_active = true;

func Transition_To(new_state:State):
	if new_state == cur_state:
		return; # If it ain't broke, don't fix it.
	cur_state = new_state;
	#play animation if it exists
	if not State.keys()[cur_state] in animated_sprite.sprite_frames.get_animation_names():
		return;
	animated_sprite.play(State.keys()[cur_state]);

func _on_animated_sprite_2d_animation_finished() -> void:
	if cur_state == State.on:
		Transition_To(State.off);
		pause_timer = interval;
