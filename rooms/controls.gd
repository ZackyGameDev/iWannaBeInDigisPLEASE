extends Node3D

func _process(delta):
	if Input.is_action_just_pressed("enter"):
		get_tree().change_scene_to_file("res://rooms/level.tscn")
