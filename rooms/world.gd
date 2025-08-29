extends Node3D
@export var initial_scroll_speed = 0.5
var scroll_speed = initial_scroll_speed
@export var max_scroll_speed = 2
var player_dash_bonus = 0

func _physics_process(delta: float) -> void:
	scroll_speed += (max_scroll_speed - initial_scroll_speed) / 2000
	if scroll_speed > max_scroll_speed:
		scroll_speed = max_scroll_speed
	for child in get_children():
		#if not child is CharacterBody3D:
		# dash bonus is set directly by player.gd
		child.position.z += scroll_speed + player_dash_bonus
