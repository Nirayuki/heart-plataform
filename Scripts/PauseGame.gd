extends ColorRect

@onready var btn_returngame = %returnGame
@onready var pauseMenu = %PauseMenu
@onready var controlMenu = %ControlMenu
@onready var returnToPauseMenu = %returnToPauseMenu


func _process(delta):
	if Input.is_action_just_pressed("esc_key"):
		get_tree().paused = true
		show()
		btn_returngame.grab_focus()

func _on_return_game_pressed():
	get_tree().paused = false
	hide()


func _on_return_menu_pressed():
	get_tree().paused = false
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Prefab/start_menu.tscn")
	LevelTransition.fade_from_black()



func _on_go_to_control_menu_pressed():
	pauseMenu.hide()
	controlMenu.show()
	returnToPauseMenu.grab_focus()


func _on_return_to_pause_menu_pressed():
	pauseMenu.show()
	controlMenu.hide()
	btn_returngame.grab_focus()
