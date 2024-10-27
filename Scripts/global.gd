extends Node

var player_name : String = ""
var score : int = 0

signal score_updated(nb : int)

func increase_score(count : int):
	score += count
	score_updated.emit(score)

func on_player_dead():
	GameSaveManager.update_player_score(player_name, score)
	
	GameSaveManager.save()
	
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")
