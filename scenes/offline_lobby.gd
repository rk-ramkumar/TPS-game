extends Node3D

@onready var character = $Character

func _ready():
	Variables.currentMap = "survival"
	var characterPath = "res://scenes/"+Variables.current_character+".tscn"
	var character_instance = load(characterPath).instantiate()
	character_instance.get_node("AnimationPlayer").play("Idle")
	character.add_child(character_instance)

func _process(delta):
	pass
