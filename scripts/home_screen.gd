extends Node

@onready var play_options_bg = $PlayOptionsBg
@onready var h_box_container = $MarginContainer/HBoxContainer

func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	play_options_bg.show()
	h_box_container.show()


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")


func _on_online_pressed():
	pass # Replace with function body.


func _on_local_pressed():
	get_tree().change_scene_to_file("res://scenes/offline_lobby.tscn")
