extends RayCast2D

var is_casting = false setget set_is_casting
var target = Vector2.ZERO

onready var line = $Line2D
onready var tween = $Tween
onready var castingParticles = $CastingParticles
onready var collisionParticles = $CollisionParticles
onready var beamParticles = $BeamParticles

func _ready():
	set_physics_process(false)
	line.points[1] = Vector2.ZERO

#func _unhandled_input(event):
#	if event is InputEventMouseButton:
#		self.is_casting = event.pressed

func _physics_process(delta):
	set_cast_to(target)
	var cast_point = cast_to
	force_raycast_update()
	
	collisionParticles.emitting = is_colliding()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		collisionParticles.global_rotation = get_collision_normal().angle()
		collisionParticles.position = cast_point
	
	line.points[1] = cast_point
	beamParticles.position = cast_point * 0.5
	beamParticles.process_material.emission_box_extents.x = cast_point.length() * 0.5

func set_is_casting(cast: bool):
	is_casting = cast
	
	beamParticles.emitting = is_casting
	castingParticles.emitting = is_casting
	if is_casting:
		appear()
	else:
		collisionParticles.emitting = false
		disappear()
	set_physics_process(is_casting)

func appear():
	tween.stop_all()
	tween.interpolate_property(line, "width", 0, 1.5, 0.2)
	tween.start()

func disappear():
	tween.stop_all()
	tween.interpolate_property(line, "width", 1.5, 0, 0.1)
	tween.start()
