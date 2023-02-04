extends KinematicBody2D

export(int) var speed = 50

enum {
	MOVE,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var proj_number = 2
var is_shooting = false

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var projectileOrigin = $ProjectileOrigin
onready var projectileDirection = $ProjectileOrigin/ProjectileDirection
onready var player = get_tree().get_current_scene().find_node("Player")

onready var Projectile = preload("res://Projectile.tscn")

func _ready():
	animationTree.active = true

func _physics_process(_delta):
	match state:
		MOVE:
			move_state(_delta)
#			if Input.is_action_just_pressed("ui_accept"):
			proj_number = 3
			state = ATTACK
		ATTACK:
			attack_state()

func move_state(_delta):
	var movement_vector = Vector2.ZERO
	movement_vector = movement_vector.normalized()
	
	if movement_vector != Vector2.ZERO:
		velocity = movement_vector
		animationState.travel("Walk")
	else:
		animationState.travel("Idle")
		velocity = Vector2.ZERO
	
	velocity = move_and_slide(velocity * speed)

func attack_state():
	velocity = Vector2.ZERO
	if !is_shooting:
		is_shooting = true
		animationState.travel("AttackStart")

# triggered when AttackStart animation is over
func shoot_projectile():
	animationState.travel("Attacking")
	while proj_number > 0:
		var projectile = Projectile.instance()
		projectile.direction = player.global_position - projectileOrigin.global_position
		projectile.global_position = projectileOrigin.global_position
		get_tree().get_current_scene().add_child(projectile)
		proj_number -= 1
		yield(get_tree().create_timer(0.5), "timeout")
		
	animationState.travel("AttackEnd")

func _on_AttackEnd_animation_finished():
		is_shooting = false
		state = MOVE
