extends StaticBody3D

var next_generated = false
@export var cpu_distance = 0.25
var generator: CharacterBody3D
var tile_length

func _ready() -> void:
	$collision.shape.size = $collision/visual.mesh.size
	$collision.position.y = $collision.shape.size.y/2
	tile_length = $collision/visual.mesh.size.z
	cpu_distance = tile_length
	generator = get_parent().get_node("generator")
	if !generator.is_on_floor() || generator.in_dash():
		#queue_free() # KILL YOURSELF
		# wait it needs to be alive to produce the next tiles after dash ends.
		$collision.disabled = true
		$collision/visual.visible = false


func _process(delta: float) -> void:
	if (global_position.z > 25):
		# you serve ZERO PURPOSE
		# you should kill yourself NOW
		queue_free()
	
	if next_generated:
		return
	
	if (position.z - tile_length) > generator.position.z - cpu_distance:
		var next_tile = preload("res://objects/floor.tscn").instantiate()
		get_parent().add_child(next_tile)
		next_tile.position = self.position
		next_tile.position.x = generator.position.x
		next_tile.position.z -= tile_length
		next_tile.position.y = 0
		next_generated = true
