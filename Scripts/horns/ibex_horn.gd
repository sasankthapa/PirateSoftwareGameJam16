extends Horn
class_name IbexHorn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	super._init(4.0,0.1) # (Attack, Defense)
	

func add_passive_power() -> void:
	player.add_modifier("CHARGE_SPEED", "horn_passive", 2.0, true)

func remove_passive_power()-> void:
	player.remove_modifier("CHARGE_SPEED","horn_passive" )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
