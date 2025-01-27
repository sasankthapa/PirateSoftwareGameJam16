extends Control

@onready var pause_menu: Control = $"."
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
		else:
			pause_menu.hide()
			get_tree().paused = false
			paused = false


func _on_resume_pressed() -> void:
	pause_menu.hide()
	get_tree().paused = false
	paused = false

func _on_options_pressed() -> void:
	print("open options")

func _on_quit_pressed() -> void:
	get_tree().quit()
