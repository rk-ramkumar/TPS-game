extends Node3D

@onready var character = $Character

func _ready():
	var characterPath = "res://scenes/"+Variables.current_character+".tscn"
	var character_instance = load(characterPath).instantiate()
	character.add_child(character_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
