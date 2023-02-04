extends KinematicBody2D

export(int) var speed = 100

var velocity = Vector2.ZERO

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

func _physics_process(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
	else:
		animationState.travel("Idle")
		velocity = Vector2.ZERO
	
	velocity = move_and_slide(velocity * speed)

func _on_Hurtbox_area_entered(projectile):
	print(projectile)
	# take damage
	pass # Replace with function body.
