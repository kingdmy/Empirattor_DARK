extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
var speed = 200
var jump_force = -200
var gravity = 1000

func _ready():
	add_to_group("player")
	if animated_sprite:
		animated_sprite.play("idle")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = 0
	var is_moving = false
	
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
		animated_sprite.flip_h = false
		is_moving = true
		
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
		animated_sprite.flip_h = true
		is_moving = true
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	# САМАЯ ПРОСТАЯ ЛОГИКА АНИМАЦИЙ:
	if is_on_floor():
		if is_moving:
			animated_sprite.play("move")
		else:
			animated_sprite.play("idle")
	
	move_and_slide()
