extends ProgressBar

@export var health: Health

func _ready():
	health.connect("damage_recieve",_on_damage_recieve)
	max_value = health.max_health
	value = health.current_health

func _on_damage_recieve():
	value = health.current_health
