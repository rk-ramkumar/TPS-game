extends Control

@onready var animated_sprite_2d = $AnimatedSprite2D
var scene_name
var scene_status

func _ready():
	scene_name = "res://scenes/main.tscn"
	ResourceLoader.load_threaded_request(scene_name)

func _process(_delta):
	animated_sprite_2d.play("loading")	
	scene_status = ResourceLoader.load_threaded_get_status(scene_name, [])
	
	if scene_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(scene_name)
		get_tree().change_scene_to_packed(new_scene)
