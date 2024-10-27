extends Node3D

@onready var log_mesh: Node3D = $logMesh

var dest : Vector2
var dist : int


func _ready() -> void:
	var laser_pos = Vector2(global_position.x, global_position.z)
	dest = (Vector2.ZERO - laser_pos).normalized()
	rotation.y = atan2(dest.x, dest.y) + (PI/2)


func _process(delta: float) -> void:
	global_position.x += dest.x * 0.2
	global_position.z += dest.y * 0.2
	log_mesh.global_rotation.z += 4 * delta
	
	dist += 1
	
	if dist > 230:
		queue_free()
		GlobalScript.increase_score(1)
		
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	GlobalScript.on_player_dead()
