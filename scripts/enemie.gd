extends CharacterBody3D

@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D

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
var state_machine

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	player = get_node(player_path)

	
func _process(delta):
	velocity = Vector3.ZERO
	
	# Added Gravity.
	if not is_on_floor():
		print("s")
		velocity.y -= gravity * delta


	nav_agent.set_target_position(player.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_position).normalized() * speed
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)

	move_and_slide()
	

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE


func _on_area_3d_area_entered(area):
	print(area)
