extends RayCast2D

var target = Vector2.ZERO

onready var line = $Line2D

func _ready():
	line.points[1] = Vector2.ZERO

func _physics_process(delta):
	set_cast_to(target)
	var cast_point = cast_to
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
	
	line.points[1] = cast_point
