extends Horn
class_name ElkHorn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	super._init(2.0,10.0) # (Attack, Defense)
	
func add_passive_power() -> void:
	player.add_modifier("MAX_HP", "Elk_horn_passive", 2.5, true)

func remove_passive_power()-> void:
	player.remove_modifier("CHARGE_SPEED","Elk_horn_passive" )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
