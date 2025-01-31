extends Horn
class_name DeerHorn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	super._init(1.0,1.0) # (Attack, Defense)
	
func add_passive_power() -> void:
	player._is_deer = true
	
func remove_passive_power()-> void:
	player._is_deer = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
