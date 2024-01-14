extends Control

@onready var intro_audio = $MarginContainer/CenterContainer/VBoxContainer/IntroAudio

func _ready():
	intro_audio.button_pressed = Variables.introAudio

func _on_check_button_toggled(button_pressed):
	Variables.introAudio = button_pressed

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/home_screen.tscn")
