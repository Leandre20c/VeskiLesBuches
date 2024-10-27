extends CanvasLayer

@onready var score_label: Label = $MarginContainer/ScoreLabel
@onready var name_label: Label = $MarginContainer/NameLabel

func _ready() -> void:
	GlobalScript.score_updated.connect(update_score)
	update_name(GlobalScript.player_name)

func update_score(nb : int) -> void:
	score_label.text = "score: " + str(nb)

func update_name(name : String) -> void:
	name_label.text = name
