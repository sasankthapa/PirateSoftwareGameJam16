extends Control

@onready var player: Player 

func calcDamage(from: Creature, to: Creature) -> float:
	return (from.ATTACK)/(to.DEFENSE)*from.SPEED/2
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
