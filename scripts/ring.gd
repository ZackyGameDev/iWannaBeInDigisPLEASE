extends Area3D

var world: Node3D

func _ready() -> void:
	world = get_parent()


func _on_body_entered(body: Node3D) -> void:
	if (body.name == "ball"):
		$collectsound.play()
		$text.text = "+" + str(int(world.score * 0.1))
		$collectparticles.emitting = true
		var tween = create_tween()
		tween.set_parallel(true) 
		tween.tween_property(self, "scale", Vector3(100, 100, 100), 3)
		tween.tween_property($visual.material_override, "albedo_color:a", 0.0, 3)
		tween.finished.connect(func(): queue_free())


func _physics_process(delta: float) -> void:
	if (global_position.z > 50):
		# you serve ZERO PURPOSE
		# you should kill yourself NOW
		queue_free()
