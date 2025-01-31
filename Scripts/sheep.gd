extends Creature

var movement_timer := 0.0
var movement_direction = Vector3.ZERO
var current_movement_duration = 0.0
var is_moving = false

var min_movement_time = 1.0
var max_movement_time = 3.0

func handle_movement(delta: float) -> void:
	super(delta)
	movement_timer += delta
	# Generate random duration between min and max time
	var current_movement_duration = randf_range(min_movement_time, max_movement_time)
	
	# Generate random angle for movement direction
	var random_angle = randf_range(0, PI * 2)
	
	# Create movement direction vector from angle
	# Note: We're only moving in the X and Z planes (horizontal movement)
	movement_direction = Vector3(
		cos(random_angle),
		0,  # No vertical movement
		sin(random_angle)
	).normalized()
	is_moving=true
	move_in_direction(movement_direction, delta)
	

func _physics_process(delta):
	super(delta)
	if movement_timer >= current_movement_duration:
		movement_timer = 0.0
		is_moving = false

func _ready():
	add_to_group("enemy")
	super()
	SPEED = 20.0
	ACCELERATION = 10.0
	ROTATION_SPEED = 2.0
	
