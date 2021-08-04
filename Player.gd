extends KinematicBody2D

const ACCELERATION = 512
const MAX_SPEED = 64
const FRICTION = 0.25
const AIR_RES = 0.02
const GRAVITY = 200
const JUMP_FORCE= 128

var motion = Vector2.ZERO

onready var Sprite = $Sprite
onready var AnimationPlayer = $AnimationPlayer

func _physics_process(delta):
	if self.position.y >= 300:
		self.position = Vector2(42, 101)
		
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if  x_input != 0:
		AnimationPlayer.play("Run")
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		Sprite.flip_h = x_input < 0
	else:
		AnimationPlayer.play("Stand")
		
	motion.y += GRAVITY * delta
	
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION)
			
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	
	else:
		AnimationPlayer.play("Jump")
		
		if Input.is_action_just_released("ui_up") && motion.y < -JUMP_FORCE / 2:
			motion.y = -JUMP_FORCE / 2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RES)
	
	motion = move_and_slide(motion, Vector2.UP)
