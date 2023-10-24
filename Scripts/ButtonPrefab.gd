extends Button

@export var text_label = ""
@export var level : PackedScene

func _ready():
	set_text(text_label)
	

func _on_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_packed(level)
