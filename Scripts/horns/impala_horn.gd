extends Horn
class_name ImpalaHorn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	super._init(1.0,0.3) # (Attack, Defense)
	
func add_passive_power() -> void:
	player.add_modifier("JUMP_VELOCITY", "horn_passive", 3.0, true)

func remove_passive_power()-> void:
	player.remove_modifier("JUMP_VELOCITY","horn_passive" )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
