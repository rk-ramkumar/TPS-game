extends CharacterBody3D

@onready var pivot = $Pivot
@onready var animation_player = $AnimationPlayer
@onready var visuals = $visuals
@onready var camera_3d = $Pivot/SpringArm3D/Camera3D
@onready var health = $Health
@onready var blood_particle = $BloodParticle
@export var game_manager: GameManager

signal died
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

enum states {
	IDLE,
	ATTACK,
	WALK,
	JUMP,
	ATTACKIDLE,
	HIT,
	DIED
}
var cur_state
var currentSpeed = 5.0
const walkingSpeed = 5.0
const sprintingSpeed = 9.0
const crouchingSpeed = 3.0

const crounchDepth = 0.7
const jumpVelocity = 20.0

const lerpSpeed = 15.0
var direction = Vector3.ZERO
const mouse_sen = 0.3
var is_sprint: bool = false

func _ready():
	cur_state = states.IDLE
	camera_3d.set_current(true)
	health.damage_recieve.connect( _on_damage_recieve)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventScreenDrag:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sen))
		pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sen))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-55), deg_to_rad(75))
		
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
		velocity.y = lerp(velocity.y, jumpVelocity, delta * lerpSpeed)
	
	# Toggle Speed.
	if Input.is_action_just_pressed("sprint"):
		is_sprint = !is_sprint

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	# Handle attack idle
	if Input.is_action_just_pressed("attack"):
		cur_state = states.ATTACKIDLE

	# Changing the state.
	if is_on_floor():
		if input_dir:
			cur_state = states.WALK
		else:
			var is_attack = cur_state != states.ATTACK and cur_state != states.ATTACKIDLE
			if is_attack:
				cur_state = states.IDLE
			else:
				cur_state = states.ATTACKIDLE
	else:
		cur_state = states.JUMP

	if Input.is_action_pressed("attack"):
		cur_state = states.ATTACK 

	_handle_animation(cur_state)
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerpSpeed)
	
	# Rotate the model to direction taht move.
	var look_dir = position + direction

	if look_dir != visuals.global_position:
		visuals.look_at(look_dir)
		
	if direction:
		velocity.x = direction.x * currentSpeed
		velocity.z = direction.z * currentSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, currentSpeed)
		velocity.z = move_toward(velocity.z, 0, currentSpeed)

	move_and_slide()

func _handle_animation(state: states):
	match state:
		states.IDLE:
			_play_anim("Idle")
		states.ATTACK:
			_play_anim("Kicking")
		states.JUMP:
			_play_anim("Jumping")
		states.WALK:
			_play_anim("WalkForward")
		states.ATTACKIDLE:
			_play_anim("FightIdle")
		states.HIT:
			_play_anim("IdleHit")
		states.DIED:
			_play_anim("Dying")

func _play_anim(anim: String):
	if animation_player.current_animation != anim:
		animation_player.play(anim)

func _on_damage_recieve():
	_handle_animation(states.HIT)
	blood_particle.set_emitting(true)
	
	# Check if health is zero or below
	if health.current_health <= 0:
		died.emit()
		_on_died()

func _on_died():
	set_physics_process(false)
	_handle_animation(states.DIED)
	
	if cur_state != states.DIED:
		# Wait for 3s to finish the dying animation
		await get_tree().create_timer(3.0).timeout
		game_manager._game_over()

func update_kill_count():
	game_manager.player_killed += 1
