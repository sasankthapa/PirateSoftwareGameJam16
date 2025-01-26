extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 4.5
const ACCELERATION = 4.0

@onready var twist_pivot: Node3D = $TwistPivot
@onready var camera: Camera3D = $TwistPivot/PitchPivot/Camera3D
@onready var body: Node3D = $body

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("A_KEY", "D_KEY", "W_KEY", "S_KEY")
	var charging := Input.is_key_pressed(KEY_K)

	if charging: # change how the movement works
		print("F")
		return
		# charge up animation

	#var direction := (twist_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#print(twist_pivot.basis)
	var direction = Vector3(input_dir.x, 0.0, input_dir.y).rotated(Vector3.UP, body.rotation.y)
	velocity = lerp(velocity, direction * SPEED, ACCELERATION * delta)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	body.rotation.y = twist_pivot.rotation.y
