extends AnimationPlayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	connect("animation_finished", get_parent().get_node("Player/SwordContainer/Sword"), "on_animation_finished")
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


