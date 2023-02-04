extends KinematicBody2D

export(int) var speed = 100

func _physics_process(delta):
	var velocity = Vector2.ZERO
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = velocity.normalized()
	
	velocity = move_and_slide(velocity * speed)
