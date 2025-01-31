# In enemy.gd
extends Creature
class_name Enemy

var target: Player
var hostile: bool

func handle_movement(delta: float) -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	target = get_tree().get_first_node_in_group("player")
	hostile = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
