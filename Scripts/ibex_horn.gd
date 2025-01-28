extends Horn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._init(1.0,1.0)


func add_passive_power() -> void:
	player.add_modifier("CHARGE_SPEED", "Ibex_horn_passive", 1.0, true)

func remove_passive_power()-> void:
	player.remove_modifier("CHARGE_SPEED","Ibex_horn_passive" )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
