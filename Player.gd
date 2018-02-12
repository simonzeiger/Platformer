extends KinematicBody2D

const MOVE_SPEED = 600
const JUMP_SPEED = 450
const JUMP_SPEED_CAP = 850
const SWORD_JUMP_MULTI = 1200
const GRAVITY = 25
const SWORD_JUMP_RELEASE_TIME = .2
const SWORD_JUMP_CD = .35


var motion = Vector2()
var jump_timer = 0
var sword_jump_timer = SWORD_JUMP_CD;
var has_released_sword = true
var num_swords_since_ground = 0
var has_moved = false
var facing_right = true


onready var sword = get_node("SwordContainer/Sword")
onready var gun = get_node("Gun")
onready var player_sprite = get_node("PlayerSprite")

func _ready():
	get_node("PlayerSprite").connect("frame_changed", self, "bobble");

func bobble():
	if get_node("PlayerSprite").get_frame() == 1:
		gun.position.y = 13
		if(facing_right):
			sword.get_node("SwordSprite").position.y = 2
		else:
			sword.get_node("SwordSprite").position.y = -2
		
	else:
		gun.position.y = 11
		sword.get_node("SwordSprite").position.y = 0

		
func animation_state_machine():
	if (get_global_mouse_position().x < get_position().x):
		if(facing_right):
			gun.flip_v = true
			facing_right = false
			player_sprite.flip_h = true
	else:
		if(!facing_right):
			gun.flip_v = false
			facing_right = true
			player_sprite.flip_h = false
			
	if(is_on_floor()):
		if(abs(motion.x) < 100):
			player_sprite.play("idle");
		elif(sword_jump_timer > SWORD_JUMP_RELEASE_TIME):
			if player_sprite.get_animation() == "jump" && sword_jump_timer > SWORD_JUMP_CD:
				player_sprite.play("run");
				player_sprite.set_frame(1)
			player_sprite.play("run");
			
	else:
		player_sprite.play("jump");
	
	
func get_motion():
	return motion

func _process(delta):
	
	animation_state_machine()
		
		
	if(sword_jump_timer > SWORD_JUMP_CD):
		if (Input.is_action_pressed("ui_right")):
			motion.x = MOVE_SPEED
		elif(Input.is_action_pressed("ui_left")):
			motion.x = -MOVE_SPEED
	
	#this is so player doesnt lerp to 0 too quickly after a sword dash
	if(sword_jump_timer > SWORD_JUMP_CD):
		motion.x = lerp(motion.x, 0, .2)
	elif(sword_jump_timer > SWORD_JUMP_RELEASE_TIME):
		motion.x = lerp(motion.x, 0, .05)

	if (has_released_sword and Input.is_mouse_button_pressed(2)):
		jump_timer = .3
		sword.swing()
		has_moved = false
		if(is_on_floor()):
			num_swords_since_ground = 0
		sword_jump_timer = 0;
		motion = Vector2(get_global_mouse_position() - get_position()).normalized() * (SWORD_JUMP_MULTI - clamp(num_swords_since_ground * 60, 0, 550)) 
		has_released_sword = false
		num_swords_since_ground += 1
	
	if (Input.is_mouse_button_pressed(1)):
		gun.fire()
		
	if(not has_released_sword and sword_jump_timer > SWORD_JUMP_CD and !Input.is_mouse_button_pressed(2)):
		has_released_sword = true
	




func _physics_process(delta):
	
	if((Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_accept"))):
		if(is_on_floor()):
			num_swords_since_ground = 0
			jump_timer = 0
			motion.y = -JUMP_SPEED
		elif(jump_timer < .3):
			motion.y = clamp(motion.y * 1.08, -JUMP_SPEED_CAP, 0)
		
	jump_timer += delta
	sword_jump_timer += delta;

	
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2(0, -1))
