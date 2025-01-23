extends RigidBody3D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input := Vector3.ZERO
	input.x = Input.get_axis("ui_left","ui_right")
	input.z = Input.get_axis("ui_up","ui_down")
	input=input.normalized()
	apply_central_force(input * 1200 * delta)
  
