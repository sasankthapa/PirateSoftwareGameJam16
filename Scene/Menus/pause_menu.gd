extends Control

@onready var pause_menu: Control = $"."
@onready var equipMenu: EquipMan = get_node("/root/World1Final/EquipManager")

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Esc"):
		if not paused:
			pause_menu.show()
			get_tree().paused = true
			paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			pause_menu.hide()
			get_tree().paused = false
			paused = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume_pressed() -> void:
	pause_menu.hide()
	get_tree().paused = false
	paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_options_pressed() -> void:
	print("open options")

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_ibex_pressed() -> void:
	equipMenu.tempHornSelect = equipMenu.ibexHorn

func _on_deer_pressed() -> void:
	equipMenu.tempHornSelect = equipMenu.deerHorn


func _on_elk_pressed() -> void:
	equipMenu.tempHornSelect = equipMenu.elkHorn


func _on_bull_pressed() -> void:
	equipMenu.tempHornSelect = equipMenu.bullHorn


func _on_buffalo_pressed() -> void:
	equipMenu.tempHornSelect = equipMenu.buffaloHorn


func _on_impala_pressed() -> void:
	equipMenu.tempHornSelect = equipMenu.impalaHorn
	


func _on_passive_pressed() -> void:
	if equipMenu.passiveHornSelect:
		equipMenu.player.unequip_horn.emit(equipMenu.passiveHornSelect)
	equipMenu.player.equip_horn.emit(equipMenu.tempHornSelect)
	equipMenu.passiveHornSelect = equipMenu.tempHornSelect
	equipMenu.passiveHornSelect.enable_passive()
	


func _on_attack_pressed() -> void:
	if equipMenu.activeHornSelect:
		equipMenu.player.unequip_horn.emit(equipMenu.activeHornSelect)
	equipMenu.player.equip_horn.emit(equipMenu.tempHornSelect)
	equipMenu.activeHornSelect = equipMenu.tempHornSelect
	equipMenu.activeHornSelect.enable_active()


func _on_defense_pressed() -> void:
	if equipMenu.blockHornSelect:
		equipMenu.player.unequip_horn.emit(equipMenu.blockHornSelect)
	equipMenu.player.equip_horn.emit(equipMenu.tempHornSelect)
	equipMenu.blockHornSelect = equipMenu.tempHornSelect
	equipMenu.blockHornSelect.enable_blocking()
