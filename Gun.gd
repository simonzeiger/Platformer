extends AnimatedSprite

const BULLET_CD = .12
const MAX_BULLETS = 10
var reload_cd = 1
var bullet_timer = 0
var bullets = MAX_BULLETS



func _ready():
	connect("animation_finished", self, "on_animation_finished")
	pass

func _process(delta):
	look_at(get_global_mouse_position())
	bullet_timer += delta;
	

func fire():
	if bullet_timer > BULLET_CD:
		if(bullets == 0):
			reload_cd = bullet_timer + 1
			bullets = -1
		elif bullets == -1:
			if(bullet_timer > reload_cd):
				bullets = MAX_BULLETS
		else:
			bullet_timer = 0
			bullets -= 1
				
			var bullet = get_parent().get_parent().get_node("Bullet").duplicate()
			bullet.set_visible(true)
			var gun_tip = get_node("GunTip")
			var gun_target = get_node("GunTip/GunTarget")
			
			#make bullet come out of center of barrel
			if(gun_target.get_global_position() .x > gun_tip.get_global_position() .x):
				gun_tip.position.y = -7 
			else:
				gun_tip.position.y = 7 
				
			bullet.set_position(gun_tip.get_global_position())
			bullet.go_to(gun_target.get_global_position(), get_parent().get_motion())
			get_parent().get_parent().add_child(bullet)
			play("default")
	
func on_animation_finished():
	stop()