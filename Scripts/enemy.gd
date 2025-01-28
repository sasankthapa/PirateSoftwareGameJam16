# In enemy.gd
extends Creature
class_name Enemy

var target: Node3D
#We need a better way to reference player node
var player: Player = get_tree().get_first_node_in_group("player")

func handle_movement(delta: float) -> void:
	if target:
		var direction = (target.global_position - global_position)
		direction.y = 0
		direction = direction.normalized()
		move_in_direction(direction, delta)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
