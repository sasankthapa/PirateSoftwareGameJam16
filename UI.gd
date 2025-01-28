extends Control

var hud:Node = null
var health_bar: ProgressBar = null
var dodge_bar: ProgressBar = null
var player : Player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud = get_node("/root/World1/CanvasLayer/PLAYERHUD")
	
	if hud == null:
		print("ERROR, hud is null")
		
	player = get_node("/root/World1/Player")
		
	health_bar = hud.get_node("Health Bar")
	health_bar.value = player.HP
	dodge_bar = hud.get_node("Dodge Bar")
		
	print("Player HP: ", player.HP)
	print("Initial health bar value: ", health_bar.value)
	
	player.hp_changed.connect(_on_player_hp_change)

func _on_player_hp_change(new_value):
	health_bar.value=new_value
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
