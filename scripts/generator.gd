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
@export var default_decision_cooldown = 30
var decision_cooldown = 20
@export var jump_chance = 0.2
@export var dash_chance_midair = 0.5
@export var dash_chance_ground = 0.05
@export var move_change_chance = 0.4

var will_dash_midair = false
var decision_timer = 0
var move_dir = 1  
var zstart;
var world: Node3D
var will_spawn_wall = false

func _ready() -> void:
	zstart = position.z
	world = get_parent()

func can_dash() -> bool:
	return dash_stamina >= dash_cooldown

func spawn_wall() -> void:
	if will_spawn_wall == true:
		var wall = preload("res://objects/wall.tscn").instantiate()
		get_parent().add_child(wall)
		wall.position = Vector3.ZERO
		wall.position.z = position.z
	will_spawn_wall = false

func spawn_ring() -> void:
	var ring = preload("res://objects/ring.tscn").instantiate()
	get_parent().add_child(ring)
	ring.position = position

func behave_dash():
	if dash_stamina < dash_time:
		velocity.y = 0
		$collision/visual.scale = Vector3(0.8, 0.8, 1.6)
		position.z -= world.scroll_speed * 0.5
		if dash_stamina == int(dash_time / 2):
			spawn_ring()
	dash_stamina += 1
	if dash_stamina > dash_cooldown:
		dash_stamina = dash_cooldown

func in_dash():
	# this is slightly more time than player,
	# so the player has a leeway on this guy.
	return dash_stamina < dash_time

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
		# on jump we decide if it will be followed by mid air dash
		will_spawn_wall = true
		if randf() < dash_chance_midair:
			will_dash_midair = true
		else:
			will_dash_midair = false
	if can_dash() and is_on_floor() and randf() < dash_chance_ground:
		dash_stamina = 0

func step(delta) -> void:
	decision_cooldown = default_decision_cooldown / world.scroll_speed
	if $collision/visual.scale != Vector3(1, 1, 1):
		var d = (Vector3(1, 1, 1) - $collision/visual.scale) / 15.0
		if d.length() < 0.0005:
			$collision/visual.scale = Vector3(1, 1, 1)
		else:
			$collision/visual.scale += d

	# AI real real fr bruh
	_cpu_decide()
	
	# acting upon the jump dash
	if will_dash_midair and can_dash() and (velocity.y < 0 and position.y < 6 and !is_on_floor()):
		dash_stamina = 0
		will_dash_midair = false
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

	# wall spawning
	if will_spawn_wall and position.y > 6:
		spawn_wall()

	behave_dash()
	move_and_slide()
	position.z -= world.scroll_speed
	
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

func _physics_process(delta) -> void:
	while (position.z > zstart):
		step(delta)
