extends Horn


var multAttack = 1.1
var multDefense = 1.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._init(20.0)

# Will be overridden by specific horn types
func passive_power(state:bool) -> void:
	if state and is_equipped:
		multAttack = 1.1
		multDefense = 1.2
	else:
		multAttack = 1.0
		multDefense = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
