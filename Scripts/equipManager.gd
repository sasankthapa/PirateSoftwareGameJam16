extends Control

var player:Player
var ibexHorn:IbexHorn = null
var deerHorn:DeerHorn = null
var ramHorn:RamHorn = null
var bullHorn:BullHorn = null
var elkHorn:BullHorn = null
var buffaloHorn:BullHorn = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame 
	player = get_tree().get_first_node_in_group("player")
	ibexHorn = get_node("/root/World1/Player/IbexHorn")
	deerHorn = get_node("/root/World1/Player/DeerHorn")
	ramHorn = get_node("/root/World1/Player/RamHorn")
	elkHorn = get_node("/root/World1/Player/ElkHorn")
	bullHorn = get_node("/root/World1/Player/BullHorn")
	buffaloHorn = get_node("/root/World1/Player/BuffaloHorn")
	
	player.unequip_horn.connect(_on_unequip_horn)
	player.equip_horn.connect(_on_equip_horn)
	
	
func _on_equip_horn(hornName):
	hornName.enable_passive()
	
func _on_unequip_horn(hornName):
	hornName.enable_passive()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
