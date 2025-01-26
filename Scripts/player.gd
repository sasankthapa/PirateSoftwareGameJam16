extends CharacterBody3D

@export_group("player")
@export var SPEED = 8.0
@export var ACCELERATION = 20.0

@onready var twist_pivot: Node3D = $TwistPivot
@onready var body: Node3D = $body
@onready var camera = $TwistPivot/PitchPivot/SpringArm3D/Camera3D
@onready var gpu_particles_3d = $body/GPUParticles3D

var rotation_speed = 5.0
var _last_movement_direction = Vector3.BACK
var _facing_direction = Vector3.BACK

var is_charging = false
var is_ramming = false
var charge_power = 1000.0
var charge_time = 0.0
var max_charge_time = 1.0
var charge_percent = 0.0
var target_velocity = Vector3.ZERO

func rotate_to_camera(delta:float):
	var forward =  -camera.global_transform.basis.z
	forward.y = 0  # Keep rotation on horizontal plane
	forward = forward.normalized()
	
	if forward.length() > 0.1:
		var target_rot = Vector3.BACK.signed_angle_to(forward, Vector3.UP)
		#body.global_rotation.y = target_rot
		body.global_rotation.y = lerp_angle(body.rotation.y, target_rot, rotation_speed * delta)
	_last_movement_direction = forward
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	# Handle charging
	if Input.is_action_pressed("ui_accept") and is_on_floor(): # use space button to charge
		charge_time = min(charge_time + delta, max_charge_time)
		velocity=Vector3.ZERO
		is_charging = true
		rotate_to_camera(delta)
		gpu_particles_3d.emitting=true  
		print("charge_time", charge_time)
		return
	if Input.is_action_just_released("ui_accept"):
		gpu_particles_3d.emitting=false
		is_charging = false
		is_ramming = true
		target_velocity = -camera.global_transform.basis.z * charge_power * charge_percent 
	
	var input_dir := Input.get_vector("A_KEY", "D_KEY", "W_KEY", "S_KEY")
	var forward: Vector3 = camera.global_basis.z
	var right: Vector3 = camera.global_basis.x
	var body_forward = _last_movement_direction
	body_forward = body_forward.normalized()
	
	var dir := forward * input_dir.y  + right * input_dir.x
	dir.y=0.0
	dir=dir.normalized()
	charge_percent = charge_time / max_charge_time
	
	var yy = velocity.y #store velocity.y because movement with camera messes with it
	velocity = velocity.move_toward(dir * SPEED + body_forward * charge_power * charge_percent, ACCELERATION * delta)
	velocity.y = yy 
	charge_time = max(charge_time - delta, 0.0)
	print("charge_time", charge_time)
	move_and_slide()
	
	# change rotation of player character
	if dir.length() > 0.2:
		_last_movement_direction=dir
	var target_angle = Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	body.global_rotation.y = lerp_angle(body.rotation.y, target_angle, rotation_speed*delta)
