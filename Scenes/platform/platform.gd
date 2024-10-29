extends Node3D

@export var log_scene : PackedScene

@onready var marker_1: Marker3D = $Platform/Marker3D
@onready var marker_2: Marker3D = $Platform/Marker3D2
@onready var marker_3: Marker3D = $Platform/Marker3D3
@onready var marker_4: Marker3D = $Platform/Marker3D4
@onready var markers := [marker_1, marker_2, marker_3, marker_4]

const LOG_Y_ADJUSTMENT := 0.2

@export var start_time := 2
# difficulty parameters
@export var wait_time := 1.5
@export var difficulty := 1
@export var difficulty_increament := 2.5
@export var log_speed_multiplicator := 1

var difficulty_counter = 0

func _ready() -> void:
	$Timer.start(start_time)
	GlobalScript.score = 0
	
	
func _on_timer_timeout() -> void:
	spawn_log(log_speed_multiplicator)
	
	$Timer.start(wait_time)
	wait_time *= 0.99
	log_speed_multiplicator += 0.15

func spawn_log(speed_factor) -> void:
	print('try to spawn')
	var log_instance : Node3D = log_scene.instantiate()
	# position
	log_instance.global_position = markers.pick_random().global_position
	# difficulty increment
	log_instance.speed *= speed_factor
	
	add_child(log_instance)
	
	log_instance.global_position.y += LOG_Y_ADJUSTMENT
