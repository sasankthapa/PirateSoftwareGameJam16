# In enemy.gd
extends Creature
class_name Enemy

var target: Player

func handle_movement(delta: float) -> void:
	if target:
		var direction = (target.global_position - global_position)
		direction.y = 0
		direction = direction.normalized()
		move_in_direction(direction, delta)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	target = get_tree().get_first_node_in_group("player")
	SPEED = 1.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
