class_name HitBox extends Area3D

@export var hit_damage: int = 20

func _init():
	collision_layer = 2
	collision_mask = 0
