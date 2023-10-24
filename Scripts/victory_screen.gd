extends ColorRect

@onready var button = %ReturnMenuBtn
@onready var morteslabel = %MortesLabel

func _ready():
	button.grab_focus()
	morteslabel.text = "Mortes: " + str(Events.death_count)

func _on_button_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Prefab/start_menu.tscn")
	LevelTransition.fade_from_black()
	get_tree().paused = false
