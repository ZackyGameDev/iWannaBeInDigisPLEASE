extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if (body.name == "ball"):
		$collectparticles.emitting = true
		var tween = create_tween()
		tween.set_parallel(true) 
		tween.tween_property(self, "scale", Vector3(2, 2, 2), 0.1)
		tween.tween_property($visual.material_override, "albedo_color:a", 0.0, 0.1)
		tween.finished.connect(func(): queue_free())


func _physics_process(delta: float) -> void:
	if (global_position.z > 25):
		# you serve ZERO PURPOSE
		# you should kill yourself NOW
		queue_free()
