extends Creature
class_name Player

@onready var camera = $TwistPivot/PitchPivot/SpringArm3D/Camera3D
@onready var gpu_particles_3d = $body/GPUParticles3D
@onready var equipMan = get_node("/root/World1/EquipManager")
@onready var animationTree = $body/PlayerDeer/AnimationTree
@onready var state_machine = animationTree.get("parameters/playback")


var _last_movement_direction = Vector3.FORWARD
var _facing_direction = Vector3.FORWARD

var _single_jump: bool
var _is_deer: bool = true

signal ram
signal charge_change
signal equip_horn(hornName:Horn)
signal collectHorn(hornName:Horn)
signal unequip_horn(hornName:Horn)

#Horns
var horn_1 : Horn = null
var horn_2 : Horn = null
var horn_3 : Horn = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("player")
	BASE_MAX_HP = 1000
	BASE_ATTACK = 20.0
	super()
	TAG = "PLAYER"
	animationTree.active = true
	state_machine.travel("Deer_Idle")
	_single_jump = false
	

func _physics_process(delta):
	super(delta)
	process_player_physics(delta)


func process_player_physics(delta):
	if Input.is_action_just_pressed("Jump"): # use space button to chargeVal
		jump()
	
		
	if Input.is_action_pressed("Centre"):
		align_camera_to_player()
		
	
	### Final alignment of the player
	#var target_angle = Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	#body.global_rotation.y = lerp_angle(body.rotation.y, target_angle, ROTATION_SPEED*delta)

	## Handle charging
	if Input.is_action_just_pressed("SHIFT_KEY"):
		gpu_particles_3d.emitting=true
		gpu_particles_3d.speed_scale = 1
		

	if Input.is_action_pressed("SHIFT_KEY"):
		charge(delta)
		charge_change.emit(CHARGE_VAL)
		state_machine.travel("Deer_RunCycle")  # Play run animation, might need to switch this one out?
		
	if Input.is_action_just_released("SHIFT_KEY"):
		gpu_particles_3d.speed_scale = 4
		discharge()
		state_machine.travel("Deer_Charge") #play charge animation
	
	if Input.is_action_pressed("DODGE"):
		equip_horn.emit(horn_1)
		#dodge_left()
		
	if Input.is_action_just_pressed("Equip"):
		horn_1 = equipMan.ibexHorn
		

func jump():
	if not _is_deer:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
	else:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			_single_jump = true
		elif _single_jump:
			velocity.y = JUMP_VELOCITY
			_single_jump = false
			
		

func ram_speed(delta):
	CHARGE_VAL = lerp(CHARGE_VAL, 0.0, 2*delta)
	charge_change.emit(CHARGE_VAL)
	if CHARGE_VAL < 0.01:
		gpu_particles_3d.emitting=false
		CHARGE_VAL=0.0 
		is_ramming=false
		remove_modifier("SPEED", "charge")
	
func _input(event: InputEvent) -> void:
	pass

func handle_movement(delta: float) -> void:
	var input_dir := Input.get_vector("A_KEY", "D_KEY", "W_KEY", "S_KEY")
	var direction = get_camera_oriented_input(input_dir)
	move_in_direction(direction, delta) 
		
	if CHARGE_VAL > 0.01: # Prevent movement animations while charging
		return
	# Store last direction input
	if direction.length() > 0.2:
		_last_movement_direction=direction	
		state_machine.travel("Deer_RunCycle") #play run animation
	else:
		state_machine.travel("Deer_Idle") #play idle animation

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

func handle_attack(enemy_body:CharacterBody3D):
	if(enemy_body.has_method("handle_knockback")):
		enemy_body.handle_knockback(velocity.normalized(),30.0)
	pass
	
func _on_area_3d_body_entered(body: Node3D) -> void: #ok, we handle every collision here for now.

	if body.is_in_group("enemy"):
		handle_attack(body as CharacterBody3D)
		print("ah its a bad dude")
	if body.is_in_group("horn"):
		print("noehauntaoneuha")
		collectHorn.emit(body as Horn)
