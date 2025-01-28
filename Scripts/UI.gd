extends Control

var hud:Node = null
var health_bar: ProgressBar = null
var dodge_bar: ProgressBar = null
var charge_bar: ProgressBar = null
var player : Player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	hud = get_node("/root/World1/CanvasLayer/PLAYERHUD")
	
	if hud == null:
		print("ERROR, hud is null")

	health_bar = hud.get_node("Health Bar")
	dodge_bar = hud.get_node("Dodge Bar")
	charge_bar = hud.get_node("Charge Bar")
	
	player = get_tree().get_first_node_in_group("player")
	
	health_bar.value = player.HP
	
	player.hp_changed.connect(_on_player_hp_change)
	player.charge_change.connect(_on_charge_change)
	

func _on_player_hp_change(new_value):
	health_bar.value=new_value
	
func _on_charge_change(new_value):
	charge_bar.value=new_value
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
