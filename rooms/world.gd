extends Node3D
@export var initial_scroll_speed = 0.5
var scroll_speed = initial_scroll_speed
@export var max_scroll_speed = 2
var player_dash_bonus = 0
var score = 0
var gameover = false

func _ready():
	$bgm.play()

func game_over():
	$bgm.stop()
	$gameovertext.text = "Game Over!\n" + "Final Score: " + str(int(score)) + "\n(Press enter)"
	gameover = true

func _physics_process(delta: float) -> void:
	if (gameover):
		$scoreboard.text = ""
		if Input.is_action_just_pressed("enter"):
			get_tree().change_scene_to_file("res://rooms/title.tscn")
		return
	scroll_speed += (max_scroll_speed - initial_scroll_speed) / 8000
	score += scroll_speed + player_dash_bonus
	if scroll_speed > max_scroll_speed:
		scroll_speed = max_scroll_speed
	for child in get_children():
		#if not child is CharacterBody3D:
		# dash bonus is set directly by player.gd
		if child is Node3D:
			child.position.z += scroll_speed + player_dash_bonus
	$scoreboard.text = "Score: " + str(int(score)) + "\nDifficulty: " + str(int((scroll_speed/max_scroll_speed)*100)) + "%"
