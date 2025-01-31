extends Control
class_name EquipMan

var player:Player
var ibexHorn:IbexHorn = null
var deerHorn:DeerHorn = null
var impalaHorn:ImpalaHorn = null
var bullHorn:BullHorn = null
var elkHorn:ElkHorn = null
var buffaloHorn:BuffaloHorn = null
var tempHornSelect: Horn = null
var activeHornSelect: Horn = null
var passiveHornSelect: Horn = null
var blockHornSelect: Horn = null



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame 
	player = get_tree().get_first_node_in_group("player")
	ibexHorn = get_node("/root/World1Final/EquipManager/IbexHorn")
	deerHorn = get_node("/root/World1Final/EquipManager/DeerHorn")
	impalaHorn = get_node("/root/World1Final/EquipManager/ImpalaHorn")
	elkHorn = get_node("/root/World1Final/EquipManager/ElkHorn")
	bullHorn = get_node("/root/World1Final/EquipManager/BullHorn")
	buffaloHorn = get_node("/root/World1Final/EquipManager/BuffaloHorn")

	player.unequip_horn.connect(_on_unequip_horn)
	player.equip_horn.connect(_on_equip_horn)
	player.collectHorn.connect(_on_collect_horn)
	
	
	
	
func _on_equip_horn(hornName: Horn):
	hornName.eqip()
	
func _on_unequip_horn(hornName:Horn):
	hornName.uneqip()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_collect_horn(hornName:Horn):
	print("meoumoeu")
	hornName.collected = true
