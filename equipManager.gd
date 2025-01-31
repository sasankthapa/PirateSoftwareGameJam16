extends Control

var player:Player
var ibexHorn:IbexHorn = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame 
	player = get_tree().get_first_node_in_group("player")
	ibexHorn = get_node("/root/World1/EquipManager/IbexHorn")
	
	
	player.unequip_horn.connect(_on_unequip_horn)
	player.equip_horn.connect(_on_equip_horn)
	
	
func _on_equip_horn(hornName):

	hornName.enable_passive()
	
func _on_unequip_horn(hornName):
	hornName.enable_passive()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
