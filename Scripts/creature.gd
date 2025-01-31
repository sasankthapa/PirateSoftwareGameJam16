extends CharacterBody3D
class_name Creature

@onready var body: Node3D = $body

## Base stats
var BASE_MAX_HP: float = 100.0
var BASE_DEFENSE: float = 0.0
var BASE_ATTACK: float = 0.0

var BASE_SPEED: float = 50
var BASE_ACCELERATION: float = 100
var BASE_JUMP_VELOCITY : float = 20
var BASE_ROTATION_SPEED : float = 10
var BASE_DODGE_SPEED: float = 30

var BASE_CHARGE_VAL: float = 0
var BASE_CHARGE_SPEED:float = 2
var BASE_MAX_CHARGE: float = 5

var TAG = "Creature"


## Current States
var HP: float
var MAX_HP: float
var DEFENSE: float
var ATTACK: float

var SPEED: float
var ACCELERATION:float 
var JUMP_VELOCITY : float 
var ROTATION_SPEED : float
var DODGE_SPEED: float

var CHARGE_VAL: float
var CHARGE_SPEED:float
var MAX_CHARGE: float

## Flags
var is_ramming:bool = false
var is_dodging: bool = false
var is_charging:bool = false
var is_charged:bool = false
var is_rolling = false


# Dictionary to store modifiers for each stat
var hp_modifiers: Dictionary = {}
var speed_modifiers: Dictionary = {}
var charge_speed_modifiers: Dictionary = {}
var max_charge_modifiers: Dictionary = {}
var attack_modifiers: Dictionary = {}
var defense_modifiers: Dictionary = {}
var jump_velocity_modifiers: Dictionary = {}



# Signals
signal hp_changed(new_HP)
signal stat_changes(Stat:String, old_value, new_value)
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
	MAX_HP = BASE_MAX_HP
	HP = MAX_HP
	DEFENSE = BASE_DEFENSE
	ATTACK = BASE_ATTACK
	
	SPEED = BASE_SPEED
	ACCELERATION= BASE_ACCELERATION
	DODGE_SPEED = BASE_DODGE_SPEED
	
	JUMP_VELOCITY = BASE_JUMP_VELOCITY
	ROTATION_SPEED = BASE_ROTATION_SPEED

	CHARGE_VAL = BASE_CHARGE_VAL
	CHARGE_SPEED = BASE_CHARGE_SPEED
	MAX_CHARGE = BASE_MAX_CHARGE

### Stat Modification Manager
# Add a modifier to a specific stat
func add_modifier(stat_name: String, modifier_id: String, value: float, is_multiplier: bool = false):
	var modifier_dict = _get_modifier_dict(stat_name)
	modifier_dict[modifier_id] = {"value": value, "is_multiplier": is_multiplier}
	_recalculate_stat(stat_name)

# Remove a modifier from a specific stat
func remove_modifier(stat_name: String, modifier_id: String):
	var modifier_dict = _get_modifier_dict(stat_name)
	if modifier_dict.has(modifier_id):
		modifier_dict.erase(modifier_id)
		_recalculate_stat(stat_name)

# Helper function to get the correct modifier dictionary
func _get_modifier_dict(stat_name: String) -> Dictionary:
	match stat_name:
		"MAX_HP": return hp_modifiers
		"SPEED": return speed_modifiers
		"ATTACK": return attack_modifiers
		"DEFENSE": return defense_modifiers
		"CHARGE_SPEED": return charge_speed_modifiers
		"MAX_CHARGE": return max_charge_modifiers
		"JUMP_VELOCITY": return jump_velocity_modifiers
		_: return {}

# Helper function to get the base stat value
func _get_base_stat(stat_name: String) -> float:
	match stat_name:
		"MAX_HP": return BASE_MAX_HP
		"SPEED": return BASE_SPEED
		"ATTACK": return BASE_ATTACK
		"DEFENSE": return BASE_DEFENSE
		"CHARGE_SPEED": return BASE_CHARGE_SPEED
		"MAX_CHARGE": return BASE_MAX_CHARGE
		"JUMP_VELOCITY": return BASE_JUMP_VELOCITY
		_: return 0.0

# Helper function to get the current stat value
func _get_current_stat(stat_name: String) -> float:
	match stat_name:
		"MAX_HP" : return MAX_HP
		"SPEED" : return SPEED
		"ATTACK" : return ATTACK
		"DEFENSE" : return DEFENSE
		"CHARGE_SPEED" : return CHARGE_SPEED
		"MAX_CHARGE" :return MAX_CHARGE
		"JUMP_VELOCITY": return JUMP_VELOCITY
		_: return 0.0

# Helper function to set the current stat value
func _set_current_stat(stat_name: String, value: float):
	match stat_name:
		"MAX_HP": MAX_HP = value
		"SPEED": SPEED = value
		"ATTACK": ATTACK = value
		"DEFENSE": DEFENSE = value
		"CHARGE_SPEED": CHARGE_SPEED = value
		"MAX_CHARGE" : MAX_CHARGE = value
		"JUMP_VELOCITY" : JUMP_VELOCITY = value
	

# Recalculate a specific stat based on its base value and all modifiers
func _recalculate_stat(stat_name: String):
	var base_value = _get_base_stat(stat_name)
	var modifier_dict = _get_modifier_dict(stat_name)
	var current_value = _get_current_stat(stat_name)
	
	# First, apply all multiplicative modifiers
	var total_multiplier: float = 1.0
	for modifier in modifier_dict.values():
		if modifier["is_multiplier"]:
			total_multiplier *= (1.0 + modifier["value"])
	
	# Apply multiplier to base value
	var after_multipliers = base_value * total_multiplier
	
	# Then, apply all additive modifiers
	var total_addition: float = 0.0
	for modifier in modifier_dict.values():
		if not modifier["is_multiplier"]:
			total_addition += modifier["value"]
	
	# Calculate final value
	var final_value = after_multipliers + total_addition
	
	# Set the new value and emit signal
	_set_current_stat(stat_name, final_value)
	stat_changes.emit(stat_name, current_value, final_value)

### Actions
func jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
func charge(delta):
	is_charging = true
	add_modifier("SPEED", "charging", -0.6, true)
	CHARGE_VAL = CHARGE_VAL + delta*CHARGE_SPEED
	CHARGE_VAL = min(CHARGE_VAL, MAX_CHARGE)
	
	if CHARGE_VAL == MAX_CHARGE:
		emit_signal("charged")
	
func discharge():
	ramem()

func ramem():
	is_ramming = true
	is_charging = false
	remove_modifier("SPEED", "charging")
	add_modifier("SPEED", "charge", CHARGE_VAL * BASE_SPEED , false)
	
	
	
func dodge_left():
	var left = body.global_transform.basis.x #dont ask me why its "-" smh
	left.y = 0
	left = left.normalized()
	is_dodging = true
	if is_on_floor() && !is_ramming && !is_charging:
			#&& dodge_cooldown.is_stopped()
		velocity = left * DODGE_SPEED
		move_and_slide()
		await get_tree().create_timer(1).timeout
		is_dodging = false 



func dodge_right():
	pass
	
func dodge_roll(dir:String):
	var right = -body.global_transform.basis.x #dont ask me why its "-" smh
	right.y = 0
	right = right.normalized()
	is_dodging = true
	#dodge_time.start() # stop movement in directions
	#dodge_cooldown.start() # cooldown for dodge

	
func attack():
	pass
	
func block():
	pass
	

## Stat changing functions	
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
		velocity.y += get_gravity().y * delta
		
func handle_movement(delta: float) -> void:
	pass
	
	
func move_in_direction(direction: Vector3, delta: float) -> void:
	if direction:
		rotate_to_direction(direction, delta)

		var yy = velocity.y
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION*delta)
		velocity.y = yy


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
		
	if is_ramming:
		ram_speed(delta)
		
func ram_speed(delta):
	CHARGE_VAL = lerp(CHARGE_VAL, 0.0, 2*delta)
	if CHARGE_VAL < 0.01:
		CHARGE_VAL=0.0 
		is_ramming=false
		remove_modifier("SPEED", "charge")
