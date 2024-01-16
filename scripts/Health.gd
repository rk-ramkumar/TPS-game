class_name Health extends Node

@export var max_health : int = 100
@export var current_health : int = max_health

signal damage_recieve

func take_damage(amount):
	# Reduce health when taking damage
	current_health -= amount
	emit_signal("damage_recieve")
