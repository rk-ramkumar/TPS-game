class_name Health extends Node

var max_health : int = 100
var current_health : int = max_health

signal died

func take_damage(amount):
	# Reduce health when taking damage
	current_health -= amount

	# Check if health is zero or below
	if current_health <= 0:
		emit_signal("died")
