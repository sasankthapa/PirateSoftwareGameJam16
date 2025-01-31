extends Enemy

func handle_movement(delta: float) -> void:
	super(delta)
	if target:
		if hostile:
			var direction = (target.global_position - global_position)
			
			direction.y = 0  # Keep movement on the horizontal plane
			direction = direction.normalized()
		
			move_in_direction(direction, delta)

func _process(delta):
	if target:
		if global_position.distance_to(target.global_position) < 40:
			hostile = true
func _ready():
	super()
	SPEED = 30.0
	ACCELERATION = 10.0
	ROTATION_SPEED = 100.0
	
