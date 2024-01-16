extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_again_pressed():
	var loading_screen = load("res://scenes/loading.tscn")
	get_tree().change_scene_to_packed(loading_screen)


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/home_screen.tscn")
