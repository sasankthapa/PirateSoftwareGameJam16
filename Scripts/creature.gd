extends CharacterBody3D
class_name Creature

# Base stats
var MAX_HP: float = 100.0
var BASE_MOVEMENT_SPEED: float = 300.0
var BASE_DEFENSE: float = 0.0
var BASE_ATTACK: float = 10.0
var JUMP_VELOCITY : float = 15.0

@export_group("Stats")
var HP: float
var SPEED: float
var DEFENSE: float
var ATTACK: float


signal state_changed(stat_name: String, old_value, new_value)
signal died

func _ready():
	# Initialize current values
	HP = MAX_HP
	SPEED = 0
	DEFENSE = BASE_DEFENSE
	ATTACK = BASE_ATTACK
	
func jump():
	velocity.y = JUMP_VELOCITY

func take_damage(new_value) -> void:
	var old_value = HP
	HP = new_value
	emit_signal("state_changed", "Health", old_value, new_value)
	
	if new_value <= 0:
		die()
		
func die() -> void:
	emit_signal("died")
	queue_free()
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
