extends Area2D

var direction = Vector2.ZERO

onready var sprite = $AnimatedSprite

func _ready():
	sprite.playing = true

func _physics_process(_delta):
	direction = direction.normalized()
	
	position.x += direction.x
	position.y += direction.y

func _on_Projectile_area_entered(_area):
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
