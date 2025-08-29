extends StaticBody3D

@export var cpu_distance = 0.25
var generator: CharacterBody3D
var tile_length

func _ready() -> void:
	$collision.shape.size = $collision/visual.mesh.size
	$collision.position.y = $collision.shape.size.y/2
	tile_length = $collision/visual.mesh.size.z
	cpu_distance = tile_length
	generator = get_parent().get_node("generator")

func _physics_process(delta: float) -> void:
	if (global_position.z > 25):
		# you serve ZERO PURPOSE
		# you should kill yourself NOW
		queue_free()
