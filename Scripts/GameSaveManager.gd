extends Node

const SAVE_FILE_PATH = "user://game.save"

# Save components
var scores = {}

# Save dict
@onready var save_data: Dictionary = {
	"scores" = scores
}


func _ready():
	load_save_file()
	

func load_save_file():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return

	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()
	file.close()

	scores = save_data.get("scores", {})

func save():
	save_data["scores"] = scores

	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()
	
	print('Game saved')

func reset_save_file():
	scores.clear()
	save()
	print("Save file reset")


func update_player_score(player_name: String, player_score: int):
	if player_name != "" && player_score != 0 && scores[player_name] < player_score:
		scores[player_name] = player_score
	
