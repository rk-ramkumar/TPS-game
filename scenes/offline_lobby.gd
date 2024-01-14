extends Node3D

@onready var character = $Character
@onready var kill_label = $Control/KillLabel

func _ready():
	Variables.currentMap = "survival"
	_update_kill_label(str(Variables.kills))
	
	var characterPath = "res://scenes/"+Variables.current_character+".tscn"
	var character_instance = load(characterPath).instantiate()
	
	character.add_child(character_instance)

func _update_kill_label(kill_count: String):
	kill_label.text = kill_count

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
