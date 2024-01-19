class_name Health extends Node

@export var max_health : int 
@export  var current_health : int = max_health

signal damage_recieve

func _ready():
	current_health = max_health

func take_damage(amount):
	# Reduce health when taking damage
	current_health -= amount
	emit_signal("damage_recieve")
