extends CharacterBody3D

@export_group("player")
@export var SPEED = 8.0
@export var JUMP_VELOCITY = 4.5
@export var ACCELERATION = 20.0

@onready var twist_pivot: Node3D = $TwistPivot
@onready var body: Node3D = $body
@onready var camera = $TwistPivot/PitchPivot/SpringArm3D/Camera3D

var _last_movement_direction = Vector3.BACK

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
	var forward: Vector3 = camera.global_basis.z
	var right: Vector3 = camera.global_basis.x
	
	var dir := forward * input_dir.y + right * input_dir.x
	dir.y=0.0
	dir=dir.normalized()
	
	var yy = velocity.y #store velocity.y
	velocity = velocity.move_toward(dir * SPEED, ACCELERATION * delta)
	velocity.y = yy
	if charging: # change how the movement works
		print("F")
		return
		# charge up animation

	#var direction := (twist_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#print(twist_pivot.basis)
	
	move_and_slide()
	
	# change rotation of player character
	if dir.length() > 0.2:
		_last_movement_direction=dir
	var target_angle = Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	body.global_rotation.y = lerp_angle(body.rotation.y, target_angle, 1*delta)
