extends Control

@onready var line_edit: LineEdit = %LineEdit

@onready var score_list: VBoxContainer = %ScoreList

func _ready() -> void:
	update_score_list()
	
	if GlobalScript.player_name != "":
		line_edit.text = str(GlobalScript.player_name)
	
func _on_button_pressed() -> void:
	if line_edit.text != "" or line_edit.text != null:
		GlobalScript.player_name = line_edit.text
		
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func add_score_label(index: int, name: String, score: int):
	var label = Label.new()
	label.text = str(index) + ": " + str(name) + " - " + str(score)
	score_list.add_child(label)
	
func update_score_list():
	var sorted_scores = GameSaveManager.scores.keys()
	sorted_scores.sort_custom(func(a, b): return GameSaveManager.scores[a] > GameSaveManager.scores[b])	
	
	var index := 0
	var player_name_list = []
	
	for player_name in sorted_scores:
		if is_player_already_exist(player_name, player_name_list):
			continue
			
		index += 1
		var player_score = GameSaveManager.scores[player_name]
		add_score_label(index, player_name, player_score)
		player_name_list.append(player_name)

func is_player_already_exist(name, tab):
	for player_name in tab:
		if player_name.to_upper().replace(" ", "") == name.to_upper().replace(" ", ""):
			return true
	
	return false
		
