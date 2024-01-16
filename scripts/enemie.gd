extends CharacterBody3D

@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D
@onready var animation_player = $AnimationPlayer

const ATTACK_RANGE = 1.0
enum states {
	IDLE,
	ATTACK,
	ROAR,
	DEAD,
	WALK,
	RUN,
	CRAWL
}

var player = null
var speed = 4.0
var cur_state

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	cur_state = states.ROAR
	_handle_animation(cur_state)
	player = get_node(player_path)
	player.connect("died", _on_player_died)

	
func _process(delta):
	velocity = Vector3.ZERO
	# Added Gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle animation
	if !_target_in_range():
		cur_state = states.WALK
		nav_agent.set_target_position(player.global_position)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_position).normalized() * speed
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	else:
		cur_state = states.ATTACK
	
	_handle_animation(cur_state)

	move_and_slide()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func _handle_animation(state: states):
	match state:
		states.IDLE:
			_play_anim("Idle")
		states.ATTACK:
			_play_anim("Attack")
		states.ROAR:
			_play_anim("Roaring")
		states.WALK:
			_play_anim("Walking")

func _play_anim(anim: String):
	if animation_player.current_animation != anim:
		animation_player.play(anim)

func _on_player_died():
	set_process(false)
	_handle_animation(states.ROAR)
