extends AudioStreamPlayer

func _process(delta):
	if Variables.introAudio:
		if !is_playing():
			play(Variables.introAudio)
	else:
		if is_playing():
			stop()

