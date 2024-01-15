extends CharacterBody3D

@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D

const jumpVelocity = 6.5

var player = null
var speed = 4.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	player = get_node(player_path)
	
func _process(delta):
	velocity = Vector3.ZERO
	
	# Added Gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Navigation.
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * speed
	
	move_and_slide()
