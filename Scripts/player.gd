extends CharacterBody3D

@export_group("player")
@export var SPEED = 30.0
@export var ACCELERATION = 60.0
@export var JUMP_VELOCITY = 15.0

@export_group("charge_attack")
@export var CHARGE_SPEED = 100.0
@export var CHARGE_ACC = 100.0

@onready var body: Node3D = $body
@onready var camera = $TwistPivot/PitchPivot/SpringArm3D/Camera3D
#@onready var gpu_particles_3d = $body/GPUParticles3D

var rotation_speed = 1.0
var _last_movement_direction = Vector3.BACK
var _facing_direction = Vector3.BACK

var is_ramming = false
var is_charging_attack = true
var charge_time = 0.0
var max_charge_time = 2.0

func rotate_to_camera(delta:float): #unused rn 
	var forward =  -camera.global_transform.basis.z
	forward.y = 0  # Keep rotation on horizontal plane
	forward = forward.normalized()
	
	if forward.length() > 0.1:
		var target_rot = Vector3.BACK.signed_angle_to(forward, Vector3.UP)
		#body.global_rotation.y = target_rot
		body.global_rotation.y = lerp_angle(body.rotation.y, target_rot, rotation_speed * delta) 
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle Jumping
	if Input.is_action_pressed("ui_accept") and is_on_floor(): # use space button to charge
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("SHIFT_KEY"):
		#gpu_particles_3d.emitting=true
		is_charging_attack = true
		charge_time = charge_time + delta
		charge_time = min(charge_time, max_charge_time)
	if Input.is_action_just_released("SHIFT_KEY"):
		#gpu_particles_3d.emitting=false
		is_ramming = true
		is_charging_attack = false
	
	var input_dir := Input.get_vector("A_KEY", "D_KEY", "W_KEY", "S_KEY")
	var forward: Vector3 = camera.global_basis.z
	var right: Vector3 = camera.global_basis.x
	var body_forward = _last_movement_direction
	body_forward = body_forward.normalized()
	
	var dir := forward * input_dir.y  + right * input_dir.x
	dir.y = 0.0
	dir = dir.normalized()

	print(charge_time)
	var yy = velocity.y #store velocity.y because movement with camera messes with it
	var newSpeed = SPEED
	var newAcceleration = ACCELERATION
	if is_ramming: #increase acceleration & speed
		newAcceleration = newAcceleration + charge_time * CHARGE_ACC
		newSpeed = newSpeed + charge_time * CHARGE_SPEED
		charge_time = lerp(charge_time, 0.0, 2*delta)
		if charge_time<0.1:
			charge_time=0.0 
			is_ramming=false
	if is_charging_attack: #decrease speed
		newSpeed = newSpeed/2
	 
	velocity = velocity.move_toward(dir * newSpeed, newAcceleration * delta)
	velocity.y = yy
	move_and_slide()
	
	# change rotation of player character
	if dir.length() > 0.2:
		_last_movement_direction=dir
	var target_angle = Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	body.global_rotation.y = lerp_angle(body.rotation.y, target_angle, rotation_speed*delta)
