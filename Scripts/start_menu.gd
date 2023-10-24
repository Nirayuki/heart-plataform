extends ColorRect

@onready var start_game_button = %StartGameButton
@onready var stat_menu_node = %StartMenuNode
@onready var levels_menu_node = %LevelsMenuNode
@onready var cenario = %Cenario
@onready var control_menu_node = %ControlMenuNode
@onready var returnToPauseMenu = %returnToPauseMenu

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	start_game_button.grab_focus()

func _on_start_game_button_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")
	LevelTransition.fade_from_black()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_levels_button_pressed():
	await LevelTransition.fade_to_black()
	levels_menu_node.show()
	stat_menu_node.hide()
	cenario.hide()
	await LevelTransition.fade_from_black()
	
	
func _on_go_back_pressed():
	await LevelTransition.fade_to_black()
	levels_menu_node.hide()
	stat_menu_node.show()
	cenario.show()
	await LevelTransition.fade_from_black()


func _on_controles_button_pressed():
	await LevelTransition.fade_to_black()
	stat_menu_node.hide()
	cenario.hide()
	control_menu_node.show()
	returnToPauseMenu.grab_focus()
	await LevelTransition.fade_from_black()


func _on_return_to_pause_menu_pressed():
	await LevelTransition.fade_to_black()
	control_menu_node.hide()
	stat_menu_node.show()
	cenario.show()
	await LevelTransition.fade_from_black()
