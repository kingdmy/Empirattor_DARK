extends CharacterBody2D

var speed = 200
var jump_force = -200
var gravity = 1000

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = 0
	
	if Input.is_action_pressed("move_right"):
		velocity.x = speed 
		print("D")
		
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
		print("A")
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force 
		print("Jump")
		
	if velocity.x != 0:
		var direction = sign(velocity.x)
		$Sprite2D.scale.x = direction
	move_and_slide()
