extends Node2D

onready var Anim = get_node("..").get_parent().get_parent().get_node("AnimationPlayer")
var look_at = true

func _ready():
	pass

func _process(delta):
	if look_at:
		look_at(get_global_mouse_position())
	pass

func swing():
	look_at = false
	get_parent().get_node("../SwordSwish").activate()
	Anim.play("SwordAnim")
	get_node("SwordSprite").rotation_degrees *= -1
	
func on_animation_finished(name):
	if(name == "SwordAnim"):
		look_at = true
		
			