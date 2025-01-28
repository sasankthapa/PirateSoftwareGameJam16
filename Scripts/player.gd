extends Creature
class_name Player

@onready var camera = $TwistPivot/PitchPivot/SpringArm3D/Camera3D
@onready var gpu_particles_3d = $body/GPUParticles3D


var _last_movement_direction = Vector3.FORWARD
var _facing_direction = Vector3.FORWARD


signal ram

#Horns
var horn_1 : Horn= null
var horn_2 : Horn = null
var horn_3 : Horn = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	print("Player HP: ", HP)
	

func _physics_process(delta):
	super(delta)
	process_player_physics(delta)


func process_player_physics(delta):
	if Input.is_action_pressed("Jump"): # use space button to chargeVal
		jump()
		
	if Input.is_action_pressed("Centre"):
		align_camera_to_player()
		
	
	## Final alignment of the player
	var target_angle = Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	body.global_rotation.y = lerp_angle(body.rotation.y, target_angle, ROTATION_SPEED*delta)

	## Handle charging
	if Input.is_action_pressed("SHIFT_KEY"):
		gpu_particles_3d.emitting=true
		gpu_particles_3d.speed_scale = 1
		charge(delta)
		
		
	if Input.is_action_just_released("SHIFT_KEY"):
		gpu_particles_3d.speed_scale = 4
		discharge(delta)

	if is_ramming:
		ram_speed(delta)
		
func ram_speed(delta):
	CHARGE_VAL = lerp(CHARGE_VAL, 0.0, 2*delta)
	if CHARGE_VAL < 0.01:
		gpu_particles_3d.emitting=false
		CHARGE_VAL=0.0 
		is_ramming=false
		SPEED = BASE_SPEED
	
func _input(event: InputEvent) -> void:
	pass

func handle_movement(delta: float) -> void:
	var input_dir := Input.get_vector("A_KEY", "D_KEY", "W_KEY", "S_KEY")
	var direction = get_camera_oriented_input(input_dir)
	move_in_direction(direction, delta) 
	
	# Store last direction input
	if direction.length() > 0.2:
		_last_movement_direction=direction	

# Transform vector in Camera FoR
func get_camera_oriented_input(input_dir: Vector2) -> Vector3:
	var direction = Vector3.ZERO
	
	if camera:
		## Use basis for camera-relative movement
		var forward: Vector3 = camera.global_basis.z
		var right: Vector3 = camera.global_basis.x
		
		direction = (forward * input_dir.y + right * input_dir.x)
		direction.y = 0;
	#
	return direction.normalized()


##Doesn't work
func align_camera_to_player():
	# Get body's forward direction
	var body_forward = -body.global_transform.basis.z
	body_forward.y = 0
	body_forward = body_forward.normalized()
	
	if body_forward.length() > 0.1:
		# Calculate target rotation based on body's forward direction
		var target_rot = Vector3.BACK.signed_angle_to(body_forward, Vector3.UP)
		# Apply to twist_pivot instead of body
		camera.rotation.y = target_rot
