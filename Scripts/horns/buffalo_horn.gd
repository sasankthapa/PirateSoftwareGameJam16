extends Horn
class_name BuffaloHorn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	super._init(1.5,5.0) # (Attack, Defense)
	
func add_passive_power() -> void:
	player.add_modifier("MAX_HP", "horn_passive",4.0, true)

func remove_passive_power()-> void:
	player.remove_modifier("MAX_HP","horn_passive" )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
