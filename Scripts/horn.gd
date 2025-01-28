class_name Horn
extends Node

signal active_power_triggered

var blocking_power: float
var damage_dealing_power:float

var is_passive_enabled: bool = false
var is_active_enabled: bool = false
var is_blocking_enabled: bool = false
var is_equipped:bool = false

func _init(blocking: float = 0.0):
	blocking_power = blocking

# Will be overridden by specific horn types
func active_power() -> void:	
	pass

# Will be overridden by specific horn types
func passive_power(state:bool) -> void:
	if state:
		pass
	else:
		pass

func enable_active() -> void:
	is_active_enabled = true
	is_blocking_enabled = false
	is_passive_enabled = false

func enable_passive() -> void:
	is_passive_enabled = true
	is_blocking_enabled = false
	is_active_enabled = false
	
func enable_blocking() -> void:
	is_blocking_enabled = true
	is_active_enabled = false
	is_passive_enabled = false

func get_blocking_power() -> float:
	return blocking_power

func set_blocking_power(value: float) -> void:
		blocking_power = value	
		

# Connect this to whatever should trigger the active power
func _on_active_power_triggered() -> void:
	active_power()
