class_name Hitbox
extends Area2D

@export var damage:int = 10.0
@export var is_active:bool = false;

func _init() -> void:
	collision_layer = 2;
	collision_mask = 0;

func test() -> void:
	position += Vector2.ZERO;
