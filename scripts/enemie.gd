extends CharacterBody3D

@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D
@onready var animation_tree = $AnimationTree

const ATTACK_RANGE = 1.0

var player = null
var speed = 4.0
var state_machine

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	player = get_node(player_path)
	state_machine = animation_tree.get("parameters/playback")
	
func _process(delta):
	velocity = Vector3.ZERO
	
	# Added Gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	match state_machine.get_current_node():
		"Walking":
			nav_agent.set_target_position(player.global_position)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_position).normalized() * speed
			look_at(Vector3(player.global_position.x + velocity.x, global_position.y, player.global_position.z + velocity.z), Vector3.UP)			
		"Attack":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	animation_tree.set("parameters/conditions/attack", _target_in_range())
	animation_tree.set("parameters/conditions/walk", !_target_in_range())
	move_and_slide()
	

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
