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
var dash_stamina = dash_cooldown

# THATS RIGHT BABY ITS TIME TO MAKE A GENERAAAAAAAAAATOR
@export var x_limit = 9.0
@export var decision_cooldown = 20
@export var jump_chance = 0.1
@export var dash_chance = 0.15
@export var move_change_chance = 0.3

var decision_timer = 0
var move_dir = 1  

func can_dash() -> bool:
	return dash_stamina >= dash_cooldown

func behave_dash():
	if dash_stamina < dash_time:
		velocity.y = 0
		$collision/visual.scale = Vector3(0.8, 0.8, 1.6)
	dash_stamina += 1
	if dash_stamina > dash_cooldown:
		dash_stamina = dash_cooldown

func in_dash():
	return dash_stamina < dash_time*5/6

func _cpu_decide():
	if in_dash():
		return

	decision_timer -= 1
	if decision_timer > 0:
		return
	decision_timer = decision_cooldown

	if randf() < move_change_chance:
		move_dir = [-1, 0, 1].pick_random()

	if is_on_floor() and randf() < jump_chance:
		velocity.y = jump_velocity
		$collision/visual.scale = Vector3(0.7, 1.5, 0.7)

	if can_dash() and (is_on_floor() or abs(velocity.y) < 1.5) and randf() < dash_chance:
		dash_stamina = 0

func _physics_process(delta) -> void:
	if $collision/visual.scale != Vector3(1, 1, 1):
		var d = (Vector3(1, 1, 1) - $collision/visual.scale) / 15.0
		if d.length() < 0.0005:
			$collision/visual.scale = Vector3(1, 1, 1)
		else:
			$collision/visual.scale += d

	# AI real real fr bruh
	_cpu_decide()

	if not in_dash():
		var direction = Vector3(move_dir, 0, 0).normalized()
		velocity.x += direction.x * accel
		if abs(velocity.x) > speed:
			velocity.x = speed * direction.x
		if direction.x == 0:
			if velocity.x > 0:
				velocity.x -= deccel
				if velocity.x < 0: velocity.x = 0
			elif velocity.x < 0:
				velocity.x += deccel 
				if velocity.x > 0: velocity.x = 0 
	else:
		velocity.x = 0;
	velocity.y -= gravity * delta

	behave_dash()
	move_and_slide()
	
	# i dont have time to make it choose to not go outta bounds
	if global_position.x < -x_limit:
		global_position.x = -x_limit
		velocity.x = 0
		move_dir = 1
	elif global_position.x > x_limit:
		global_position.x = x_limit
		velocity.x = 0
		move_dir = -1

	pvsp = abs(velocity.y)
	if is_on_floor() and pvsp > 1:
		if pvsp > 20: pvsp = 20
		$collision/visual.scale = Vector3(1.6, 0.5, 1.6) * pvsp/20
