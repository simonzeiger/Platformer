extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func activate():
	var mouse = get_global_mouse_position()
	if(mouse.x > get_global_position().x):
		get_node("Light2D").set_scale(Vector2(.5,.5))
		set_flip_v(false)
	else:
		set_flip_v(true)
		get_node("Light2D").set_scale(Vector2(.5,-.5))
	look_at(get_global_mouse_position())

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
