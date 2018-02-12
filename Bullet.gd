extends Area2D

const SPEED_MULTI = 1700
const MAX_DIST = 800
var target = Vector2()
var movement = Vector2()
var spawn = Vector2(-1000, -10000)

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	connect("body_entered", self, "destroy")
	
func destroy(obj):
	queue_free()
	
func go_to(pos, motion):
	spawn = get_position()
	movement = (pos - spawn).normalized()
	movement *= (SPEED_MULTI)
	rotation_degrees = (57.2958 * acos(movement.dot(Vector2(1,0))/SPEED_MULTI)) + 90
	if(movement.y < 0):
		rotation_degrees *= -1


func _physics_process(delta):
	if(spawn != Vector2(-1000, -10000)):
		position += movement*delta
		if((get_position() - spawn).length_squared() > MAX_DIST * MAX_DIST):
			destroy(null)
		
