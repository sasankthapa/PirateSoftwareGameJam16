extends Enemy

func handle_movement(delta: float) -> void:
	super(delta)
	if target:
		var direction = (target.global_position - global_position)
		if direction.y > 0:
			jump()
			
		direction.y = 0  # Keep movement on the horizontal plane
		direction = direction.normalized()
		

		move_in_direction(direction, delta)
	
func _ready():
	super()
	SPEED = 30.0
	ACCELERATION = 100.0
	
