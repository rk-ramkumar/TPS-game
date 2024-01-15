extends CharacterBody3D

@onready var pivot = $Pivot
@onready var animation_player = $AnimationPlayer
@onready var visuals = $visuals
@onready var animation_tree = $AnimationTree

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var currentSpeed = 5.0
const walkingSpeed = 5.0
const sprintingSpeed = 9.0
const crouchingSpeed = 3.0

const crounchDepth = 0.7
const jumpVelocity = 6.5

const lerpSpeed = 15
var direction = Vector3.ZERO
const mouse_sen = 0.3
var is_sprint: bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sen))
		pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sen))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))
		
func _physics_process(delta):
	
	if is_sprint:
		currentSpeed = sprintingSpeed
	else:
		currentSpeed = walkingSpeed

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpVelocity
	
	# Toggle Speed.
	if Input.is_action_just_pressed("sprint"):
		is_sprint = !is_sprint
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerpSpeed)
	
	if direction:
		animation_tree.set("parameters/conditions/walk", true)
		
		visuals.look_at(position + direction)
		velocity.x = direction.x * currentSpeed
		velocity.z = direction.z * currentSpeed
	else:
		animation_tree.set("parameters/conditions/idle", true)
		
		velocity.x = move_toward(velocity.x, 0, currentSpeed)
		velocity.z = move_toward(velocity.z, 0, currentSpeed)

	move_and_slide()
