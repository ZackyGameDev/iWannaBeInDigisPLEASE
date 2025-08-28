extends CharacterBody3D

@export var speed = 22.0
@export var accel = 1.5
@export var deccel = 2.5
@export var jump_velocity = 20.0
@export var stomp_speed = 30.0
@export var gravity = 50.0
@export var dash_cooldown = 60
@export var dash_time = 30
var pvsp = 0.0
var squash_thresh = 0.1
var dash_stamina = dash_cooldown

func can_dash() -> bool:
	return dash_stamina >= dash_cooldown

func behave_dash():
	if (dash_stamina < dash_time):
		velocity.y = 0
		$collision/visual.scale = Vector3(0.8, 0.8, 1.6)
	dash_stamina += 1
	if dash_stamina > dash_cooldown: dash_stamina = dash_cooldown

func in_dash(): 
	return dash_stamina < dash_time*5/6

func _physics_process(delta) -> void:
	if $collision/visual.scale != Vector3(1, 1, 1):
		var d = (Vector3(1, 1, 1) - $collision/visual.scale)/10.0
		if d.length() < 0.0005:
			$collision/visual.scale = Vector3(1, 1, 1)
		else:
			$collision/visual.scale += d
	var direction = Vector3.ZERO
	
	if not in_dash():
		if Input.is_action_pressed("ui_right"):
			direction.x += 1
		if Input.is_action_pressed("ui_left"):
			direction.x -= 1
	
	direction = direction.normalized()

	# acceleration
	velocity.x += direction.x * accel
	if abs(velocity.x) > speed:
		velocity.x = speed * direction.x
	
	# decceleration
	if (direction.x == 0):
		if (velocity.x > 0):
			velocity.x -= deccel
			if velocity.x < 0: velocity.x = 0
		elif velocity.x < 0:
			velocity.x += deccel 
			if velocity.x > 0: velocity.x = 0 


	if not is_on_floor():
		if Input.is_action_just_pressed("ui_down"):
			velocity.y -= stomp_speed
			$collision/visual.scale = Vector3(0.6, 1.8, 0.6)
	elif Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_velocity
		$collision/visual.scale = Vector3(0.7, 1.5, 0.7)

	velocity.y -= gravity * delta
	# dash
	if Input.is_action_just_pressed("ui_accept"):
		if (can_dash()):
			dash_stamina = 0;
	behave_dash()
	
	pvsp = abs(velocity.y)
	if move_and_slide():
		if (pvsp > 1):
			if (pvsp > 20): pvsp = 20
			$collision/visual.scale = Vector3(1.3, 0.7, 1.3) * pvsp/20
	
