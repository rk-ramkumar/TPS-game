extends Control

func _on_resume_pressed():
	get_tree().set_pause(false)

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/home_screen.tscn")
