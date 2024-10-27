extends Camera3D

@export var player : CharacterBody3D
@export var FOV : float = 50
@export var distance : float = 10.0  # Distance de la caméra par rapport au joueur
@export var sensitivity : float = 0.005  # Sensibilité de la souris
@export var height_offset : float = 2.0  # Hauteur de la caméra par rapport au joueur

@onready var starting_pos = position

var rotation_x : float = 0.0  # Pour stocker la rotation en X (pitch)
var rotation_y : float = 0.0  # Pour stocker la rotation en Y (yaw)

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capture la souris pour cacher le curseur

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * sensitivity
		rotation_x += event.relative.y * sensitivity
		
		# Limiter le pitch pour éviter que la caméra ne fasse un tour complet
		rotation_x = clamp(rotation_x, deg_to_rad(-30), deg_to_rad(30))  # Restreint le pitch pour une vue agréable

func _physics_process(delta: float) -> void:
	# Calculer la position de la caméra en fonction de la rotation
	var offset : Vector3 = Vector3(0, height_offset, -distance).rotated(Vector3(1, 0, 0), rotation_x).rotated(Vector3(0, 1, 0), rotation_y)
	
	# Définir la position de la caméra à une distance donnée du joueur
	global_position = player.global_position + offset
	
	# Toujours faire regarder la caméra vers le joueur
	look_at(player.global_position, Vector3.UP)
	
	# Tourner le joueur pour qu'il suive la caméra (sur l'axe Y seulement)
	player.rotation_degrees.y = rotation_y * 180 / PI + 180  # Convertir la rotation en degrés
	
	# Gestion du champ de vision dynamique
	var disered_fov = FOV + Vector2(player.velocity.x, player.velocity.z).length()
	fov = lerp(fov, disered_fov, 0.1)
