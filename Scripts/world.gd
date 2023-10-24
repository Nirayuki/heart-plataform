extends Node2D

@export var next_level : PackedScene
@onready var level_completed := $CanvasLayer/LevelCompleted
@onready var start_in = %Startin
@onready var start_in_label = %StartinLabel
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var victory_screen = %VictoryScreen
@onready var example_walljump = $Walljump as VFlowContainer
@onready var pause_game = $CanvasLayer/PauseGame


func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.level_completed.connect(show_level_completed)
	# Criando um metodo onde, primeiro paro o game, faço a animação, espero ela acabar e dps volto o game dnv  a vida
	get_tree().paused = true
	start_in.visible = true
	await LevelTransition.fade_from_black()
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false
	start_in.visible = false


func show_level_completed():
	level_completed.show()
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout
	if not next_level is PackedScene: 
		victory_screen.visible = true
		level_completed.hide()
		return

	# Pausando o jogo e fazendo a animação de fade in e fade out
	get_tree().paused = true
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)

func _on_action_example_wall_jump_body_entered(body):
	example_walljump.visible = true
