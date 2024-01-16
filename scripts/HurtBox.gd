class_name HurtBox extends Area3D

@export var health : Health

func _init():
	collision_layer = 0
	collision_mask = 2

func _ready():
	connect("area_entered", _on_area_entered )

func _on_area_entered(hitBox: HitBox):
	if hitBox:
		health.take_damage(hitBox.hit_damage)
