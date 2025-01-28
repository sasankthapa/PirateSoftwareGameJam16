extends CharacterBody3D

var health = 100

@export_group("player")
@export var SPEED = 40.0
@export var ACCELERATION = 40.0
@export var JUMP_VELOCITY = 15.0

@export_group("charge_attack")
@export var CHARGE_SPEED = 100.0
@export var CHARGE_ACC = 100.0

@onready var body: Node3D = $body
@onready var camera = $TwistPivot/PitchPivot/SpringArm3D/Camera3D
@onready var gpu_particles_3d = $body/GPUParticles3D
@onready var dodge_time = $dodge_time
@onready var dodge_cooldown = $dodge_cooldown

var rotation_speed = 1.0
var _last_movement_direction = Vector3.BACK
var _facing_direction = Vector3.BACK

var is_dodging = false
var dodge_speed = 30.0
var dodge_direction = Vector3.ZERO

var is_ramming = false
var is_charging_attack = false
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

func dodge_roll(dir:String):
	var right = -body.global_transform.basis.x #dont ask me why its "-" smh
	dodge_bar.value = 0
	right.y = 0
	right = right.normalized()
	is_dodging = true
	dodge_time.start() # stop movement in directions
	dodge_cooldown.start() # cooldown for dodge
	if dir == "left":
		dodge_direction = -right
	else:
		dodge_direction = right
	velocity = dodge_direction * dodge_speed
	is_dodging = false 
	move_and_slide()

var hud:Node = null
var health_bar: ProgressBar = null
var dodge_bar: ProgressBar = null

func _ready():
	hud = get_node("/root/World1/CanvasLayer/PLAYERHUD")
	if hud == null:
		print("ERROR, hud is null")
	health_bar = hud.get_node("Health Bar")
	health_bar.value=health
	dodge_bar = hud.get_node("Dodge Bar")
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle Jumping
	if Input.is_action_pressed("ui_accept") and is_on_floor() and not is_charging_attack: 
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("SHIFT_KEY") and is_on_floor():
		gpu_particles_3d.emitting=true
		gpu_particles_3d.speed_scale = 1
		is_charging_attack = true
		charge_time = charge_time + delta
		charge_time = min(charge_time, max_charge_time)
	if Input.is_action_just_released("SHIFT_KEY"):
		gpu_particles_3d.speed_scale = 4
		is_ramming = true
		is_charging_attack = false
	if is_on_floor() and Input.is_action_pressed("DODGE") && !is_ramming && !is_charging_attack && dodge_cooldown.is_stopped():
		on_hit()
		if Input.is_action_pressed("A_KEY"):
			dodge_roll("left")
		if Input.is_action_pressed("D_KEY"):
			dodge_roll("right")
			
	var input_dir := Input.get_vector("A_KEY", "D_KEY", "W_KEY", "S_KEY")
	var forward: Vector3 = camera.global_basis.z
	var right: Vector3 = camera.global_basis.x
	var body_forward = _last_movement_direction
	body_forward = body_forward.normalized()
	
	var dir := forward * input_dir.y  + right * input_dir.x
	dir.y = 0.0
	dir = dir.normalized()

	var yy = velocity.y #store velocity.y because movement with camera messes with it
	var newSpeed = SPEED
	var newAcceleration = ACCELERATION
	if is_ramming: #increase acceleration & speed
		newAcceleration = newAcceleration + charge_time * CHARGE_ACC
		newSpeed = newSpeed + charge_time * CHARGE_SPEED
		charge_time = lerp(charge_time, 0.0, 2*delta)
		if charge_time<0.1:
			gpu_particles_3d.emitting=false
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
	if !dodge_time.is_stopped():
		_last_movement_direction = body.global_transform.basis.z
	var target_angle = Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	body.global_rotation.y = lerp_angle(body.rotation.y, target_angle, rotation_speed*delta)
	
func on_hit():
	health-=10
	health_bar.value=health

func _on_dodge_cooldown_timeout(): # this is a "signal" from Timer node
	dodge_bar.value=2
