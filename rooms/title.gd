extends Node3D

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"): # usually space/enter
		OS.shell_open("https://zackygamedev.itch.io")
	if Input.is_action_just_pressed("open_with_s"):
		OS.shell_open("https://github.com/ZackyGameDev/iWannaBeInDigisPLEASE")
	if Input.is_action_just_pressed("enter"):
		get_tree().change_scene_to_file("res://rooms/controls.tscn")
