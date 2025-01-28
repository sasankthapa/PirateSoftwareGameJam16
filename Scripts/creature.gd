extends CharacterBody3D
class_name Creature

@onready var body: Node3D = $body

## Base stats
var MAX_HP: float = 100.0
var BASE_DEFENSE: float = 0.0
var BASE_ATTACK: float = 10.0

var BASE_SPEED: float = 40.0
var BASE_ACCELERATION: float = 40.0
var BASE_JUMP_VELOCITY : float = 15.0
var BASE_ROTATION_SPEED : float = 2.0

var BASE_CHARGE_VAL: float = 1.0
var BASE_CHARGE_SPEED:float = 1.0
var BASE_MAX_CHARGE: float = 3.0


## Current States
var HP: float
var DEFENSE: float
var ATTACK: float

var SPEED: float
var ACCELERATION:float 
var JUMP_VELOCITY : float 
var ROTATION_SPEED : float

var CHARGE_VAL: float
var CHARGE_SPEED:float
var MAX_CHARGE: float

## Flags
var is_ramming:bool = false
var is_dodging: bool = false
var is_charging:bool = false
var is_charged:bool = false

# Signals
signal hp_changed(new_HP)
signal died
signal hit
signal charged

func _ready():
	intialize()
	
func _physics_process(delta):
	apply_gravity(delta)
	handle_movement(delta)
	move_and_slide()
	process_creature_physics(delta)
	
func intialize():
		# Initialize current values
	HP = MAX_HP
	DEFENSE = BASE_DEFENSE
	ATTACK = BASE_ATTACK
	
	SPEED = BASE_SPEED
	ACCELERATION= BASE_ACCELERATION
	
	JUMP_VELOCITY = BASE_JUMP_VELOCITY
	ROTATION_SPEED = BASE_ROTATION_SPEED

	CHARGE_VAL = BASE_CHARGE_VAL
	CHARGE_SPEED = BASE_CHARGE_SPEED
	MAX_CHARGE = BASE_MAX_CHARGE

func reset_speed():
	SPEED = BASE_SPEED
	ACCELERATION= BASE_ACCELERATION

func jump():
	velocity.y = JUMP_VELOCITY
	
	
func charge(delta):
	is_charging = true
	CHARGE_VAL = CHARGE_VAL + delta*CHARGE_SPEED
	CHARGE_VAL = min(CHARGE_VAL, MAX_CHARGE)
	
	if CHARGE_VAL == MAX_CHARGE:
		emit_signal("charged")
	
func discharge(delta):
	is_ramming = true
	is_charging = false
	SPEED = SPEED + CHARGE_VAL * BASE_SPEED
	

	
func dodge():
	pass
	

func change_HP(new_value) -> void:
	var old_value = HP
	HP = new_value
	hp_changed.emit(new_value)
	
	if new_value <= 0:
		die()
		
func take_damage(damage)-> void:
	change_HP(HP-damage)
		
func die() -> void:
	emit_signal("died")
	queue_free()
	
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func handle_movement(delta: float) -> void:
	pass

func move_in_direction(direction: Vector3, delta: float) -> void:
	if direction:
		rotate_to_direction(direction, delta)
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION*delta)
	else:
		stop_movement()

func rotate_to_direction(direction: Vector3, delta: float) -> void:
	var target_rotation = atan2(direction.x, direction.z)
	var current_rotation = body.global_rotation.y
	body.global_rotation.y = lerp_angle(current_rotation, target_rotation, ROTATION_SPEED * delta)
	

func stop_movement() -> void:
	velocity.x = 0
	velocity.z = 0

func process_creature_physics(delta: float) -> void:
	pass
	
