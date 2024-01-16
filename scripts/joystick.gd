extends CanvasLayer

@onready var touch_screen_button = $Titan/TouchScreenButton
@onready var timer = $Titan/Timer
@onready var label = $Titan/Label

var can_change_titan: bool = false
var time_left = 0

func _ready():
	if !can_change_titan:
		touch_screen_button.set_modulate(Color(91, 91, 91, 0.1))
		label.show()
		time_left = timer.get_time_left()
		if time_left != 0:
			_update_remaining_time()
	else:
		timer.stop()

func _process(delta):
	time_left = round(timer.get_time_left())	
	_update_remaining_time()

func _update_remaining_time():
	label.text = str(time_left)

func _on_timer_timeout():
	can_change_titan = true
	touch_screen_button.set_modulate(Color.WHITE)
	touch_screen_button.action = "titan"
	label.hide()
