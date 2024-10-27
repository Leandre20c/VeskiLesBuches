extends Node3D

@export var laser_scene : PackedScene

@onready var marker_1: Marker3D = $Platform/Marker3D
@onready var marker_2: Marker3D = $Platform/Marker3D2
@onready var marker_3: Marker3D = $Platform/Marker3D3
@onready var marker_4: Marker3D = $Platform/Marker3D4

@onready var markers = [marker_1, marker_2, marker_3, marker_4]

@export var difficulty = 1
@export var default_timer = 1.25

@export var difficulty_increament = 2.5

@export var log_y_ajustment := -0.2

var difficulty_counter = 0

func _ready() -> void:
	$Timer.start(2)
	GlobalScript.score = 0
	

func _on_timer_timeout() -> void:
	spawn_laser()
	$Timer.start(default_timer * (1 / difficulty))
	difficulty_counter += 1
	
	if (difficulty_counter > difficulty_increament):
		difficulty += 1
		difficulty_counter = 0


func spawn_laser() -> void:
	var laser_instance : Node3D = laser_scene.instantiate()
	laser_instance.global_position = markers.pick_random().global_position
	add_child(laser_instance)
	laser_instance.global_position.y += log_y_ajustment
