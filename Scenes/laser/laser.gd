extends Node3D

@onready var log_mesh: Node3D = $logMesh

@export var speed := 8.0

var dest : Vector2
var dist : int



func _ready() -> void:
	var laser_pos = Vector2(global_position.x, global_position.z)
	dest = (Vector2.ZERO - laser_pos).normalized()
	rotation.y = atan2(dest.x, dest.y) + (PI/2)
	
	speed += randf_range(-3, 3)


func _process(delta: float) -> void:
	global_position.x += dest.x * speed * delta
	global_position.z += dest.y * speed * delta
	log_mesh.global_rotation.z += 4 * delta
	
	var border = 25
	
	if (global_position.x > border or
	 global_position.x < -border or
	 global_position.z > border or
	 global_position.z < -border):
		queue_free()
		GlobalScript.increase_score(1)
		

func _on_area_3d_body_entered(body: Node3D) -> void:
	GlobalScript.on_player_dead()
