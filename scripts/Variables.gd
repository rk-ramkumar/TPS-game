extends Node

var introAudio = true
var current_character = "eren"
var characterList = ["eren", "jaw"]
var currentMap
var kills = 0
var user_prefs : UserManager

func _ready():
	_load_data()
	
func save_data():
	user_prefs.introAudio = introAudio
	user_prefs.kills = kills
	user_prefs.save()

func _load_data():
	user_prefs = UserManager.load_or_create()
	introAudio = user_prefs.introAudio
	kills = user_prefs.kills
