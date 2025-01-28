class_name Horn
extends Node

signal active_power_triggered

var blocking_power: float
var damage_dealing_power:float

var is_passive_enabled: bool = false
var is_active_enabled: bool = false
var is_blocking_enabled: bool = false
var is_equipped:bool = false

@onready var player: Player = get_tree().get_first_node_in_group("player")

func _init(damage_dealing:float = 0, blocking: float = 0.0):
	damage_dealing_power = damage_dealing
	blocking_power = blocking

# Will be overridden by specific horn types
func active_power() -> void:	
	pass

# Will be overridden by specific horn types
func add_passive_power() -> void:
	pass
	
func remove_passive_power() -> void:
	pass

func enable_active() -> void:
	is_active_enabled = true
	is_blocking_enabled = false
	is_passive_enabled = false
	player.add_modifier("ATTACK", "Horn", damage_dealing_power, true)
	remove_passive_power()
	player.remove_modifier("DEFENSE", "Horn")
	

func enable_passive() -> void:
	is_passive_enabled = true
	is_blocking_enabled = false
	is_active_enabled = false
	player.remove_modifier("ATTACK", "Horn")
	add_passive_power()
	player.remove_modifier("DEFENSE", "Horn")
	
func enable_blocking() -> void:
	is_blocking_enabled = true
	is_active_enabled = false
	is_passive_enabled = false
	player.remove_modifier("ATTACK", "Horn")
	remove_passive_power()
	player.add_modifier("DEFENSE", "Horn", blocking_power, true)

func get_blocking_power() -> float:
	return blocking_power

func set_blocking_power(value: float) -> void:
		blocking_power = value	
		

# Connect this to whatever should trigger the active power
func _on_active_power_triggered() -> void:
	active_power()
