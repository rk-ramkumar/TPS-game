extends Node

var introAudio = true


func _notification(what):
	var backRequest = what == NOTIFICATION_WM_WINDOW_FOCUS_OUT or what == NOTIFICATION_WM_GO_BACK_REQUEST

	if backRequest:
		get_tree().set_pause(true)
		get_tree().change_scene_to_file("res://scenes/pause_screen.tscn")
		pass
