class_name GameManager extends Node

signal toggle_game_paused(is_paused: bool)
@export var map: Node3D
@export var game_over: CanvasLayer

var start_time : float = 0.0

var game_paused: bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

func _ready():
	start_time = Time.get_ticks_msec()

func _notification(what):
	var backRequest = what == NOTIFICATION_WM_WINDOW_FOCUS_OUT or what == NOTIFICATION_WM_GO_BACK_REQUEST

	if backRequest:
		game_paused = true

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		notification.call(NOTIFICATION_WM_GO_BACK_REQUEST)

func _game_over(kill_count: int):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if kill_count > Variables.kills:
		Variables.kills = kill_count
		
	var survival_time = round((Time.get_ticks_msec() - start_time) / 1000.0)
	
	game_over.get_node("CenterContainer/VBoxContainer/SurvivalTime").text = str(survival_time) + " s"
	game_over.get_node("CenterContainer/VBoxContainer/Kills").text ="Kills: " + str(kill_count)
	game_over.get_node("$BestKills").text = "Best Kills:  " + str(Variables.kills)

	remove_child(map)
	game_over.show()
